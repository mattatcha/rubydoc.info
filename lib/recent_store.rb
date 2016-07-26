class RecentStore
  def initialize(maxsize = 20)
    @maxsize = maxsize
  end

  def push(library_versions)
    library_name = library_versions.first.name
    recent = get
    if recent.none? {|t| t.first.name == library_name }
      recent.unshift(library_versions)
    end

    recent = recent[0, @maxsize] # truncate
    File.open(RECENT_DB_FILE, File::RDWR|File::CREAT) do |f|
      f.flock(File::LOCK_EX)
      f.rewind
      f.write(Marshal.dump(recent))
      f.flush
    end
  end

  def get
    File.open(RECENT_DB_FILE, "r") do |f|
      f.flock(File::LOCK_SH)
      Marshal.load(f.read)
    end
  rescue IOError, Errno::ENOENT
    []
  end

  def size
    get.size
  end

  def each(&block)
    get.each(&block)
  end
end
