#
# Install the revison control systems we use: git, mercurial, etc.
#

# Should I do defines like this?
# * http://docs.puppetlabs.com/guides/language_guide.html
#
# define hg_clone($name, $uri, $cwd) {
#     exec {"hg-clone":
#         cwd => "{$cwd}",
#         path => "hg clone ${uri} ${name}",
#         unless => "/bin/test -d ${name}",
#     }
# }

# define git_clone($name, $uri, $cwd) {
#     exec {"hg-clone":
#         cwd => "{$cwd}",
#         path => "git clone ${uri} ${name}",
#         unless => "/bin/test -d ${name}",
#     }
# }

class rcs_deps {
    include git
    include mercurial::client

    Class["user_settings"] -> Class["git"] -> Class["mercurial::client"]
}