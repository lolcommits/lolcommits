#!/usr/bin/env ruby

require 'rubygems'
require 'RMagick'
require 'git'
require 'choice'
include Magick

#
# Command line parsing fun
#
$VERBOSE = nil
Choice.options do
  option :about do
    long "--about"
    action do
      puts "LOL!!!"
      exit
    end
  end
  option :test do
    long "--test"
    desc "Run in test mode, to be called manually (dont actually read git repo)"
  end
  option :sha do
    desc "pass a SHA manually (for test mode only!)"
    short '-s'
    default "test-123456789"
  end
  option :msg do
    desc "pass a commit message manually (for test mode only!)"
    short '-m'
    default "this is a test message i didnt really commit something"
  end
end


#
# Read the git repo information from the current working directory
#
g = Git.open('.')
if not Choice.choices[:test]
  commit = g.log.first
  commit_msg = commit.message
  commit_sha = commit.sha[0..10]
else
  commit_msg = Choice.choices[:msg]
  commit_sha = Choice.choices[:sha]
end

#
# Create a directory to hold the lolimages
#
loldir = "#{g.dir}/.lolcommits"
if not File.directory? "#{loldir}/tmp"
  #FileUtils.mkdir_p loldir
  FileUtils.mkdir_p "#{loldir}/tmp"
end

#
# SMILE FOR THE CAMERA! 3...2...1...
# We're just assuming the captured image is 640x480 for now, we may
# need updates to the imagesnap program to manually set this (or resize)
# if this changes on future mac isights.
#
puts "*** Preserving this moment in history."
system("imagesnap -q #{loldir}/tmp/snapshot.jpg")

#
# Process the image with ImageMagick to add loltext
#
canvas = ImageList.new.from_blob(open("#{loldir}/tmp/snapshot.jpg") { |f| f.read } )

canvas << Magick::Image.read("caption:#{commit_msg}") { 
  self.gravity = SouthWestGravity
  self.size = "640x480"
  self.font = "/Library/Fonts/Impact.ttf"
  self.pointsize = 48
  self.fill = 'white'
  self.stroke = 'black'
  self.stroke_width = 2
  self.background_color = 'transparent'
}.first

canvas << Magick::Image.read("caption:#{commit_sha}") { 
  self.gravity = NorthEastGravity
  self.size = "640x480"
  self.font = "/Library/Fonts/Impact.ttf"
  self.pointsize = 32
  self.fill = 'white'
  self.stroke = 'black'
  self.stroke_width = 2
  self.background_color = 'transparent'
}.first

#
# Squash the images and write the files
#
canvas.flatten_images.write("#{loldir}/#{commit_sha}.jpg")
#system("open #{loldir}/#{commit_sha}.jpg")
