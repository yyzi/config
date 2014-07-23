# Copyright 2010-2014 Wincent Colaiuta. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

require 'mkmf'

def header(item)
  unless find_header(item)
    puts "couldn't find #{item} (required)"
    exit 1
  end
end

# mandatory headers
header('float.h')
header('ruby.h')
header('stdlib.h')
header('string.h')

# optional headers (for CommandT::Watchman::Utils)
if have_header('fcntl.h') &&
  have_header('sys/errno.h') &&
  have_header('sys/socket.h')
  RbConfig::MAKEFILE_CONFIG['DEFS'] += ' -DWATCHMAN_BUILD'

  have_header('ruby/st.h') # >= 1.9; sets HAVE_RUBY_ST_H
  have_header('st.h')      # 1.8; sets HAVE_ST_H
end

# optional
if RbConfig::CONFIG['THREAD_MODEL'] == 'pthread'
  have_library('pthread', 'pthread_create') # sets HAVE_PTHREAD_H if found
end

RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']

create_makefile('ext')