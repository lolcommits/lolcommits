module Lolcommits
  class VCSInfo
    def self.repo_root?(path = '.')
      GitInfo.repo_root?(path) || MercurialInfo.repo_root?(path)
    end

    def self.local_name(path = '.')
      if GitInfo.repo_root?(path)
        GitInfo.local_name(path)
      elsif MercurialInfo.repo_root?(path)
        MercurialInfo.local_name(path)
      else
        raise "'#{File.expand_path(path)}' is not the root of a supported VCS"
      end
    end
  end
end
