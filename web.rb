require 'launchy'

@urls = []

def web()
  if ARGV.length > 0
    new_element = ARGV[0]
    if args(new_element) == 1
      return
    end

    # Open the file for reading and writing
    File.open(__FILE__, 'r+') do |file|

      lines = file.readlines #an array

      # Find the line with the array definition
      arr_line_index = lines.find_index { |line| line.include?('urls = [') }
      arr_line_index_end = lines.find_index { |line| line.include?(']') }
      if arr_line_index != arr_line_index_end
        puts "too many sites"
        return
      end

      # Extract current elements from the array definition
      match_result = lines[arr_line_index].match(/urls = \[(.*)\]/)
      current_elements = match_result ? match_result[1] : nil

      if current_elements && !current_elements.strip.empty?
        # Modify the array definition with the new element
        lines[arr_line_index] = "@urls = [#{current_elements}, '#{new_element}']\n"
      else
        # Modify the array definition with the new element
        lines[arr_line_index] = "@urls = ['#{new_element}']\n"
      end

      # Go back to the start of the file and write the modified lines
      file.seek(0)
      file.write(lines.join)
      file.truncate(file.pos)
    end

  else

    @urls.each do |url|
      begin
        Launchy.open(url)
      rescue
        puts "a site failed to load"
      ensure
        sleep(1) # Optional, just to give some time for the browser to react
      end
    end

  end #if end
end #web()

def clean()
  File.open(__FILE__, 'r+') do |file|

    lines = file.readlines #an array

    # Find the line with the array definition
    arr_line_index = lines.find_index { |line| line.include?('@urls = [') }
    arr_line_index_end = lines.find_index { |line| line.include?(']') }
    if arr_line_index != arr_line_index_end
      puts "too many sites, need to do manually"
      return
    end
    lines[arr_line_index] = "@urls = []\n"
    # Go back to the start of the file and write the modified lines
    file.seek(0)
    file.write(lines.join)
    file.truncate(file.pos)
  end
end

def args(new_element)
  if new_element == 'list' 
    puts @urls.inspect
    return 1
  end

  if new_element == 'clean' 
    clean()
    return 1
  end

end


web
