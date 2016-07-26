module DockerRunner
  module_function

  def docker_command(command, extra_docker_opts = "")
    if ENV['DOCKERIZED']
      "docker run --volumes-from #{ENV['HOSTNAME']} -u `id -u`:`id -g` " +
        "#{extra_docker_opts} docmeta/rubydoc.info #{command}".sub(/[ ]+/, ' ')
    else
      command
    end
  end
end
