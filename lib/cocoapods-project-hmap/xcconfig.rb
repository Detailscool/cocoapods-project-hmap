# frozen_string_literal: true

# !/usr/bin/env ruby

module Xcodeproj
  class Config
    def remove_attr_with_key(key)
      @attributes.delete(key) unless key.nil?
    end

    def remove_header_search_path
      header_search_paths = @attributes['HEADER_SEARCH_PATHS']
      if header_search_paths
        new_paths = []
        header_search_paths.split(' ').each do |p|
          new_paths << p unless p.include?('${PODS_ROOT}/Headers')
        end
        if new_paths.size.positive?
          @attributes['HEADER_SEARCH_PATHS'] = new_paths.join(' ')
        else
          remove_attr_with_key('HEADER_SEARCH_PATHS')
        end
      end
      remove_system_option_in_other_cflags
    end

    def remove_system_option_in_other_cflags
      flags = @attributes['OTHER_CFLAGS']
      if flags
        new_flags = ''
        skip = false
        flags.split(' ').each do |substr|
          if skip
            skip = false
            next
          end
          if substr == '-isystem'
            skip = true
            next
          end
          new_flags += ' ' if new_flags.length.positive?
          new_flags += substr
        end
        if new_flags.length.positive?
          @attributes['OTHER_CFLAGS'] = new_flags
        else
          remove_attr_with_key('OTHER_CFLAGS')
        end
      end
    end

    def reset_header_search_with_relative_hmap_path(hmap_path)
      # remove all search paths
      remove_header_search_path
      # add build flags
      new_paths = Array["${PODS_ROOT}/#{hmap_path}"]
      header_search_paths = @attributes['HEADER_SEARCH_PATHS']
      new_paths.concat(header_search_paths.split(' ')) if header_search_paths
      @attributes['HEADER_SEARCH_PATHS'] = new_paths.join(' ')
    end

    def set_use_hmap(use = false)
      @attributes['USE_HEADERMAP'] = (use ? 'YES' : 'NO')
    end
  end
end
