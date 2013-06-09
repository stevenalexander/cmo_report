# encoding: utf-8
require 'spreadsheet'
require 'json'

class XlsParser
  attr_accessor :xls
  def initialize file_path
    @file_name = File.basename(file_path)
    @xls = Spreadsheet.open(file_path)
  end

  def is_summary_sheet(worksheet)
    worksheet.row(1).join(',').include? "Summary sheet"
  end

  def is_data_sheet(worksheet)
    worksheet.row(0).join(',').include? "CMO Annual Report"
  end

  def print_sheets
    begin
      (0..@xls.sheet_count).each do |i|
        puts "sheet #{i}"
        j = 0
        sheet = @xls.worksheet(i)
        sheet.each do |row|
          puts "#{j}: #{row.join(',')}"
          j += 1
       end
      end
    rescue
    end
  end

  def generate_json(json_file_path)
    content = {
      :orginal_file_name => @file_name,
      :summary => nil,
      :data => []
    }

    (0..@xls.sheet_count).each do |i|
      sheet = @xls.worksheet(i)
      next if sheet.nil?

      if is_summary_sheet(sheet)
        content[:summary] = generate_summary_hash(sheet)
      elsif is_data_sheet(sheet)
        content[:data] << generate_data_hash(sheet)
      end
    end

    File.open(json_file_path, 'w+') {|f| f.write(content.to_json) }
  end

  def generate_summary_hash(worksheet)
    summary = {}

    worksheet.each do |row|
      next if row.nil? || row.length < 3
      parse_metadata_row(row, summary)
    end

    summary
  end

  def generate_data_hash(worksheet)
    data = { :metadata => {}, :data => [] }
    data_sheet_ons_column_header = "ONS 9 character code"
    found_data_column_header = false
    headers = []

    worksheet.each do |row|
      next if row.nil?
      is_header_row = false

      if !found_data_column_header && row.join(',').include?(data_sheet_ons_column_header)
        found_data_column_header = true
        is_header_row = true
        headers = row.map { |cell| cell.to_s.strip }
      end

      if !found_data_column_header
        parse_metadata_row(row ,data[:metadata], 2)
      elsif !is_header_row
        data[:data] << parse_data_row(row, headers)
      end
    end

    data
  end

  def parse_metadata_row(row, hash, data_start_index = 1)
    return nil if row.nil? && row.length < data_start_index+2

    key = row[data_start_index]
    value = row[data_start_index+1]
    if !key.nil?   && !key.to_s.empty? &&
       !value.nil? && !value.to_s.empty?
      hash[key] = value
    end
  end

  def parse_data_row(row, headers)
    return nil if row.nil? && row.length < headers.length
    data_row = {}

    headers.each_with_index do |header, i|
      data_row[header] = row[i] if !header.empty?
    end

    data_row
  end

end