### Set the role
#role :web, %w{mike@watchmetrain.net}
server 'watchmetrain.net', user: 'mike', roles: %w{web}, pty: :true

### Set some global ssh options
set :ssh_options, {
  forward_agent: false,
}
