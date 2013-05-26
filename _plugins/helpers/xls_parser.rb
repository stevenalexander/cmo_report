# encoding: utf-8
require 'spreadsheet'

class XlsParser
  def initialize file_path
    @xls = Spreadsheet.open(file_path)
    puts @xls.worksheet(0).row(1)[1]
  end
end