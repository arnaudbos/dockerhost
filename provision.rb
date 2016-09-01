module Provision
  def Provision.get_subfolders(path)
    return Dir.entries(path)
      .select{|name| name if name != '.' and name != '..'}
      .map{|name| Hash["name", name,
                       "path", File.join(path, name)]}
      .map{|subfolder| subfolder.merge(
                        Hash["symlink", File.lstat(subfolder['path']).symlink?]
                        ) if File.directory? subfolder['path']}
      .compact
  end

  def Provision.share_folder!(config, folder, guest, follow_symlinks)
    host = File.expand_path(folder['path'])
    if follow_symlinks and folder['symlink']
      host = File.expand_path(File.readlink(host))
    end
    guest = File.join(guest, folder['name'])
    config.vm.synced_folder host, guest
  end
end
