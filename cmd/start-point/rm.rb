
def cyber_dojo_start_point_rm
  help = [
    '',
    "Use: #{me} start-point rm NAME",
    '',
    "Removes a start-point created with the [#{me} start-point create] command"
  ]

  image_name = ARGV[2]
  if [nil,'-h','--help'].include?(image_name)
    show help
    exit succeeded
  end

  exit_unless_start_point_image(image_name)

  unless ARGV[3].nil?
    puts "ERROR: unknown argument [#{ARGV[3]}]"
    exit failed
  end

  run("docker image rm #{image_name} &> /dev/null")
  if $exit_status != 0
    puts "ERROR: cannot remove start-point #{image_name}. A container is probably using it."
    exit failed
  end
end
