# Function: unix_crypt_password
# This function is used to create a unix crypt password hash
# with salt
# algorithm: crypt

module Puppet::Parser::Functions
  newfunction(:unix_crypt_password, :type=>:rvalue) do |args|
    salt = args[0]
    password = args[1]
    # yes, yes i know this is stupid,
    # it looks ugly and is probably a security issue:
    # 1. using an external call here ...omfg
    # 2. using a static salt string
    # 3. using a dynamic salt is also a problem,
    # because than the puppet module isn't idempotent anymore
    return %x(openssl passwd -1 -salt #{salt} #{password}).chomp!
  end
end
