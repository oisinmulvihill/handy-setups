define git::hook (
  $git_dir,
  $hook,
  $content,
  $owner = root,
){

  file { "${git_dir}/hooks/${hook}":
    owner   => $owner,
    mode    => 700,
    content => $content,
  }

}
