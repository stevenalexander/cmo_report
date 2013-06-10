# encoding: utf-8
class String
  def to_slug
    slug = self.strip.downcase
    slug.gsub! /['`]/,""
    slug.gsub! /\s*@\s*/, " at "
    slug.gsub! /\s*&\s*/, " and "
    slug.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '-'
    slug.gsub! /-+/,"-"
    slug.gsub! /\A[-\.]+|[-\.]+\z/,""

    slug
  end
end