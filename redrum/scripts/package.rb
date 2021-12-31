#!env ruby
#
# Copyright (C) 2010-2021, Jason Colburne
# All rights reserved.
#
# $Id: package.rb 19 2010-04-14 16:54:52Z jason $

# usage:
#  ruby package.rb <yaml input file> [<red target>] <release suffix>
 
require 'yaml'
require 'pp'

if ARGV.count < 2 || ARGV.count > 4
  puts 'usage:'
  puts ' ruby package.rb <yaml input file> <release suffix> [<red_target>] [<red_build>]'
  exit
end


$RED_TARGET       = nil
$RED_BUILD        = nil


if ARGV.count >= 4
  $RED_TARGET = ARGV.pop
end

if ARGV.count >= 3
  $RED_BUILD = ARGV.pop
end

$SUFFIX     = ARGV.pop
$INPUT      = ARGV.pop

yaml = YAML::load_file($INPUT)
$CONFIG   = yaml['configuration']
$CONTENTS = yaml['contents']
$PROJROOT = $CONFIG['root']
$PKGBASE  = $CONFIG['basename'] + '-' + $SUFFIX
$PKGBASE += '-' + $RED_TARGET if $RED_TARGET
$PKGBASE += '-' + $RED_BUILD  if $RED_BUILD
$TEMPROOT = $PROJROOT + '/' + $CONFIG['temporary'] + '/' + $PKGBASE + '/'

# make sure your yaml is correct or you may clobber something unintentionally
def packageTempDirCreate
  `rm -rf #{$PROJROOT}/#{$CONFIG['temporary']}` if File.exists?($CONFIG['temporary'])
  `mkdir -p #{$TEMPROOT}`
end

def copyGlob(from, dest, perm)
  destIsDir = false

  if dest =~ /(.*)\/\*$/
    dest = $1
    `mkdir -p #{dest}` unless File.exists?(dest)
    destIsDir = true
  elsif from =~ /\*/
    puts "[!] Error, destination for glob must end in /*"
    exit 1
  end

  Dir[from].each do |file|
    file =~ /\/([^\/]*?)$/
    filename = $1

    innerDest = dest
    innerDest += '/' + filename if destIsDir

    if ($CONFIG['ignore-svn'] && file =~ /\/\.svn$/) ||
       ($CONFIG['ignore-git'] && file =~ /\/\.git$/) ||
       ($CONFIG['ignore-cvs'] && file =~ /\/CVS$/)   ||
       ($CONFIG['ignore-priv'] && filename =~ /^_/)
      next
    elsif File.directory?(file)
      copyGlob(file + '/*', innerDest + '/*', perm)
    else
      puts ": cp #{filename} -> #{innerDest} ..."
      `cp #{file} #{innerDest}`
      File.chmod(perm, innerDest)
    end
  end
end



# main

#Dir.chdir($CONFIG['root'])
packageTempDirCreate()

$CONTENTS.each_value do |items|
  next if not items
  items.each do |item|
    from = $PROJROOT + '/' + item['from']
    dest = $TEMPROOT + item['to']

    if $RED_BUILD
      from.gsub!("RED_BUILD", $RED_BUILD)
      dest.gsub!("RED_BUILD", $RED_BUILD)
    end

    if $RED_TARGET
      from.gsub!("RED_TARGET", $RED_TARGET)
      dest.gsub!("RED_TARGET", $RED_TARGET)
    end

    copyGlob(from, dest, item['permissions'])
  end
end

`rm -rf #{$PROJROOT}/#{$CONFIG['destination']}`
`mkdir -p #{$PROJROOT}/#{$CONFIG['destination']}`

$OLDPWD = Dir.getwd
Dir.chdir($TEMPROOT)
puts ": creating archive #{$PKGBASE}.zip"
`zip -r ../#{$PKGBASE}.zip *`
Dir.chdir($OLDPWD)
puts ": mv #{$PROJROOT}/#{$CONFIG['temporary']}/#{$PKGBASE}.zip -> #{$PROJROOT}/#{$CONFIG['destination']}"
`mv #{$PROJROOT}/#{$CONFIG['temporary']}/#{$PKGBASE}.zip #{$PROJROOT}/#{$CONFIG['destination']}`
`rm -rf #{$PROJROOT}/#{$CONFIG['temporary']}`
