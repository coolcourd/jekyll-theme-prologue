# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "jekyll-theme-prologue"
  spec.version       = "0.3.2"
  spec.authors       = ["HTML5 UP", "Chris Bobbe"]
  spec.email         = ["csbobbe@gmail.com"]

  spec.summary       = %q{A Jekyll version of the Prologue theme by HTML5 UP.}
  spec.description   = "A Jekyll version of the Prologue theme by HTML5 UP. Demo: https://chrisbobbe.github.io/jekyll-theme-prologue/"
  spec.homepage      = "https://github.com/chrisbobbe/jekyll-theme-prologue"
  spec.license       = "CC-BY-3.0"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(assets|_layouts|_includes|_sass|_config.yml|404.html|LICENSE|README)}i) }

  spec.add_development_dependency "jekyll", "~> 3.3"
  spec.add_development_dependency "bundler", "~> 1.12"
end

require 'json'
require 'fileutils'

module Jekyll
  class PostsJsonGenerator < Generator
    priority :low

    def generate(site)
      site.config['posts_json_path'] = 'posts.json' if !site.config['posts_json_path']

      json_file = File.new(File.join(site.config['destination'], site.config['posts_json_path']), 'w')

      posts = []

      site.posts.each do |post|
        posts << {
          :date => post.date,
          :url => post.url,
          :title => post.title,
          :excerpt => post.excerpt,
          :tags => post.tags
        } if post.published?
      end

      json_file.write(posts.to_json)
      json_file.close

      site.static_files << Jekyll::JsonFile.new(site, site.config['destination'], "/", site.config['posts_json_path'])
    end
  end

  class JsonFile < StaticFile
    def write(dest)
      begin
        super(dest)
      rescue
      end

      true
    end
  end

  class PostsJsonTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      IO.read(File.join(context.registers[:site].config['destination'], context.registers[:site].config['posts_json_path']))
    end
  end
end

Liquid::Template.register_tag('posts_json', Jekyll::PostsJsonTag)
