class profiles::base {
  $groups = hiera_hash('group', undef)
  if $groups {
    create_resources('@group', $groups)
  }
  Group <| tag == 'base' |>

  $accounts = hiera_hash('account', undef)
  if $accounts {
    create_resources('@account', $accounts)
  }
  Account <| tag == 'base' |>

  $yumrepos = hiera_hash('yumrepo', undef)
  if $yumrepos {
    create_resources('@yumrepo', $yumrepos)
  }
  Yumrepo <| tag == 'base' |>
  Yumrepo <| tag == "${osfamily}-${operatingsystemmajrelease}" |>
  Yumrepo <| tag == "${osfamily}-${operatingsystemrelease}" |>
  Yumrepo <| tag == "${operatingsystem}-${operatingsystemmajrelease}" |>
  Yumrepo <| tag == "${operatingsystem}-${operatingsysterelease}" |>

  $packages = hiera_hash('package', undef)
  if $packages {
    create_resources('@package', $packages)
  }
  Package <| tag == 'base' |>
}
