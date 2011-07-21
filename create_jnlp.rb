#!/usr/bin/env ruby

unless ARGV and ARGV.size>2 and File.directory?(ARGV[0])
  puts "please give <dir> <host> <www_dir>"
  exit 1
end

dir = File.expand_path(ARGV[0])
host = ARGV[1]
www = ARGV[2]

unless File.directory?(File.join(dir,"ches-mapper_lib"))
  puts "not found: "+File.join(dir,"ches-mapper_lib")
  exit 1
end

unless dir.start_with?(www)
  puts "directory '"+dir+"' not in www_dir '"+www+"'"
  exit 1
end
url = File.join(host,dir.gsub(www,""))

jnlp = <<EOF
<?xml version="1.0" encoding="utf-8"?> 
<jnlp spec="1.0+" codebase="
EOF
jnlp.chomp!
jnlp += url
jnlp += <<EOF
" href="ches-mapper.jnlp">
        <information>
                <title>CheS-Mapper</title>
                <vendor>Martin Guetlein</vendor>
                <description>Initial Prototype</description>
        </information>
        <security>
                <all-permissions/>
        </security>
        <resources>
          <j2se version="1.6+" />
          <jar href="ches-mapper.jar" main="true" />
EOF
Dir.glob( File.join(dir,"ches-mapper_lib","**","*.jar") ) do |f|
    file = File.new(f)
    ff = file.path.gsub!(dir,"")
    jnlp += "          <jar href='"+ff+"' download='lazy' />\n"
end     
jnlp += <<EOF
        </resources>
    <application-desc main-class="gui.CheSViewer" />
</jnlp>
EOF

puts jnlp