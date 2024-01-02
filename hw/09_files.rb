Dir.pwd                                 # current working directory
Dir.chdir('new/dir')                    # change current working directory
Dir.mkdir('newdir')                     # create new directory
Dir.entries('.')                        # lists files/directories in current directory
Dir.foreach('.')                        # iterate on files/directories in current directory

File.new('file.txt', 'r')               # create new file
# 2nd param is mode:
#   r - readonly
#   r+ - read/write
#   w - write
#   w+ - read/write
#   a - write, pointer @end of file
#   a+ - read/write, pointer @end of file
#   b - binary mode (windows only)

file = File.open('file.txt')            # open file, can add 'r' param for read-only
file.closed?                            # is file already open?
file.close                              # close file
file.rename                             # rename file
file.delete                             # delete file
File.exists?('file.txt')                # find file
File.file?('file.txt')                  # is a file? (as opposed to directory)
File.directory?('file.txt')             # is a directory?
File.readable?('file.txt')              # is readable?
File.writable?('file.txt')              # is writable?
File.executable?('file.txt')            # is executable?
File.size('file.txt')                   # file size
File.zero?('file.txt')                  # file is empty
File.ftype('file.txt')                  # file type
File.ctime('file.txt')                  # file created timestamp
File.mtime('file.txt')                  # file modified timestamp
File.atime('file.txt')                  # file last access timestamp

# once a file is opened, can do stuff with it
string = file.readline                  # read file line
file.each{|line| print "do stuff" }     # read all file lines
file.getc.chr                           # read file character

file.putc('c')                          # write character to file
file.puts('string')                     # write string to file
file.rewind                             # move pointer back to start of file
