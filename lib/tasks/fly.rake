# commands used to deploy a Rails application
namespace :fly do
  # RELEASE step:
  #  - changes to the filesystem made here are DISCARDED
  #  - full access to secrets, databases
  #  - failures here prevent deployment
  task release: "db:migrate"

  # SERVER step:
  #  - changes to the filesystem made here are deployed
  #  - full access to secrets, databases
  #  - failures here result in VM being stated, shutdown, and rolled back
  #    to last successful deploy (if any).
  task server: :swapfile do
    sh "bin/rails server -p 3000 -b 0.0.0.0"
  end

  # optional SWAPFILE task:
  #  - adjust fallocate size as needed
  #  - performance critical applications should scale memory to the
  #    point where swap is rarely used.  'fly scale help' for details.
  #  - disable by removing dependency on the :server task, thus:
  #        task :server do
  task :swapfile do
    sh "fallocate -l 512M /swapfile"
    sh "chmod 0600 /swapfile"
    sh "mkswap /swapfile"
    sh "echo 10 > /proc/sys/vm/swappiness"
    sh "swapon /swapfile"
  end
end
