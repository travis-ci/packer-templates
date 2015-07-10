default['travis_internal_base']['opsmatic_disabled'] = false

override['openssh']['server']['password_authentication'] = 'no'
override['openssh']['server']['pubkey_authentication'] = 'yes'
override['openssh']['server']['permit_root_login'] = 'no'
override['openssh']['server']['kex_algorithms'] = %w(
  curve25519-sha256@libssh.org
  diffie-hellman-group-exchange-sha256
  diffie-hellman-group14-sha1
).join(',')
override['openssh']['server']['protocol'] = '2'
override['openssh']['server']['host_key'] = %w(
  /etc/ssh/ssh_host_ed25519_key
  /etc/ssh/ssh_host_rsa_key
)
override['openssh']['server']['ciphers'] = %w(
  chacha20-poly1305@openssh.com
  aes256-gcm@openssh.com
  aes128-gcm@openssh.com
  aes256-ctr
  aes192-ctr
  aes128-ctr
).join(',')
override['openssh']['server']['m_a_cs'] = %w(
  hmac-sha2-512-etm@openssh.com
  hmac-sha2-256-etm@openssh.com
  hmac-ripemd160-etm@openssh.com
  umac-128-etm@openssh.com
  hmac-sha2-512
  hmac-sha2-256
  hmac-ripemd160
  umac-128@openssh.com
  hmac-sha1
).join(',')

override['users'] = [
  {
    'id' => 'hiro',
    'shell' => '/bin/zsh',
    'ssh_keys' => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAqrJ+ONnuVcwsSgZrb9vLY9c6atszjRa5vsuMpNRwzvzKClkQ+lOwgQGb9cg7Me6RVUUx06RKCKQ2VBhVAoo6chZ1Fe8hd5gnGuVGRcFJU+IpWP1tkXvyt9uGfgv8fcChdqFcU8vZcYg0GsfDu9lNH9qm41uxad0NqE3OCDmfgIMHWRXa07ApzdUvjdaaD+exqhQwAA82od1a0m0fSqQPo35N0BOdBQCRmJylw/lT1Ij2MeGRA1Dfgd19e8oBBhwGEE/TqIjQ+mptIbsbNfUMsVEKTNTDH9h4R1Vhfv9cqXMi6xUWLJq6WRTYhjcaCYLzjURbUmyUu82c87id0sqTXw==',
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA4RfZ+ZgTAqEGejs/yhFrdNG9dgf3RQwHmn/28rMO38Fn5Mu3ZG/2dGP+GQWFId9u1OA5Q7aMFfUQAacNw+2SWwmM5rTS/JzG6BzVzJDfp18dCIPwhcEsZhjjPA9DQtuTk9XRMKbHBdxy6YrbyyKo+d6XyJpE6HfI0bn8eUJ9LaIxuoiUEmLczNhZyrvG45jXMw3JvUgKxeKc9uGYmeDvBeun3qALbuZaBmB2hssw5m2jkaLXhyHNSc+gS85nWT1+YL1pH1i6PGK4L2CXakyGmjTPzF0VGRG73ddjE1cLgiEmVcznkIuNmp696Rz6xpfWnrbL+Q7kmluqTX2sGgTJFQ==',
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA3RiJaQS4UtlGHFHg2ZVyZF/xbdA8AiX2Kq1hIJKJ27LPbVtx0TOSkocRgoKte7GbClYqrEGpU89inKYwfbJiyZ7729qevpYnVJYovaENTNSVog+VNkijkmzojHQWAsJEI4AqKh+Mkr2tnN1MOswhEmX6rLKKt0BtGqBfCftoB4PgoqQ3tuPhx2FC1UnhRGw65Ec0ZCCrACzaEk+7WRZq0/1IAJXgv31ll/k9ct1C4jxCeGfqIxjD7mx8NPdXjoPERdMEhpwDWz4zOx1a+rGWrVzLPeziDLwR+X/US2g4r50ZGRBn4TjGroleTJtgijr2prgvA2QvG/D+XU6Ng3MNnQ=='
    ]
  },
  {
    'id' => 'piotr',
    'shell' => '/bin/zsh',
    'ssh_keys' => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA32inBfC8n8/KMH4FdKk4i9+XqNFM586zI9rQd1Ltnp7kooipsE57bkECuiw5OxDv3MicGbyxIeoKnv6ZBNinXRuZefcAPYGleum062f3lLpZpHN4DNjP1MFM7MYeZclBcYN+EjdNiiygMfE7hWDujj9UjiWIzVec2W8JLORWboBJN2w+sD19znNq5V/x+UowEjZ063GpenXSWJ2NBGLtunweQ7suJ9HO9KzmM3wbnaSeUNw3Uj0HVS2rvEM1OF4zrLu1aerVejrNGD7VOAoyWtQzv9nVI7Rg8dA/xQESkqS0PJgCGVyYYaxad2rOH2CU2tgm9QgmYJEazGx8PjZ93w==',
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCq7cemt2pT41VFvyq07tzFcUy64KlR325fk9XC+YEXFNjANk9RugdP86BAzKSbYz4+658ldj8rDf0yx7svcV7scD516orpXHH5lyJrix6RIKPJ45ZNb1YThc+fCd1lyAAKL8zv64a3dPZGr1UFpYAbaRQylbWI1bwRM+LxD3lvs2abfrxydEQPvkCxqVIfoBx9YmoYDSTQtEzF7Y82/EOOyz+w0x48gdC+BtwCH2nMVS6DPR7cDZwyfFRaOqoJPlqK6QA3cFxpAy7jCYQDUcJ875EjFkcWQjftA5a62mxxuxMV1gIHBRvWVy64Ztr9HmMAgb99ct0WGHnD4CSTYtKP'
    ]
  },
  {
    'id' => 'emma',
    'shell' => '/bin/zsh',
    'ssh_keys' => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHqcfkZKY3QqcAwEd6yUHCpmfX3ATcYEB+4YaClTSXH1JpRzUz3ShfN4ikvdk7/Y/FgxX7qKupYL3U+K6INqVPa9krvydqnNYT0vIwmnjUDPXc0aCDcnqkeeXj5KznKWN9aHnvd7nHRAy7Zi2Oq1O9QEb0KBZGLNMtECCueiBXBSww9RqqNFbY2WAWj2ul5zrqRzM9oYCCiVi7MlTCVzlcKv5n1kwgY1vy4Y1USLJIAXXhKhbNJengM6z90E/eOx7NVCmeIpbiSaup/Ds/AFwPHxNtpg75/q+Atmf0VuFLnFdcEQO2VreoNFOUlUe0nG6npieWNtqidFi1oNYeBCEl',
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFI2IFyH4GPa5EPo/dzbBBWHKGZUEDwFLn5sOxNGpJU4loDJFIPd5PVIcqS1jNuqqBc5cwbybhl4f375DWZ9l0/tvkQCf4g7x/MfJ5dJr71qWLNX9CTEKfowaP/GfOxHs1XswhWrfUR3n6CHo+Tp3yDMnqq4kDNvQwYdYb/S7HYufWBcKENZVJUNGI8i92YnqZk9yu6XBRDdRpGAlY1TMJwTVJqYXmI2eUzZjHbonkt+dF6es/7h9GlqQS2VzCPja8OkpTDd1qgZvjmk2mXcja+Z8DQYNvf1dnvNCusUapT6+AxVpFv2MtlIcFJfe3+4o4v1WxRFz9X6bKpn9oEGQP'
    ]
  },
  {
    'id' => 'henrik',
    'shell' => '/bin/zsh',
    'ssh_keys' => [
      'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL02vDvGkgyDZKNvOs0UcY+d2laL42gy/YMRwOt6iqDY'
    ]
  },
  {
    'id' => 'josh',
    'shell' => '/bin/zsh',
    'ssh_keys' => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAmsGtcUlDwNPZ0jRSiY4cdb60sPrPJddRDUE1272W9NKZupcAOfsp04BxwO4lr2pp9p/BE2P2J6vSVhPKW/PzkhjXPTBYoHLAfRBSgTsLGrxL5HbeztVtmUviI0clWcpxK0CQlsIGEh/sJxSNya0bSEFmj8L3yl0kacYBHr0gl+KcfY3ClviE8KRmGwF2p6xZohMHwbngzeEYOxNLQA98wGQgrSMIKj4QI5c/yeFmf0YPjObRjVnSnvZNzohQXwYlrb724s65P6Aq6zvBIxGqPOyWJhRUTPw6ge3Mzru+Mr5mciJJahH2HTsR6Q4q5CGA9O88YHZOGEOF5WkFQcdpBQ==',
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA8QloPabcfiYEps1oJgzOAz1TZo2Lsfj4opGLzPk9KHVlX8rzeh1JmqYUuKnExuMt3Qyu3d7UHDvi0jhNRSbaccmZOdf8ne8yv+ozUNedpG3N5/G5DTC2Y6Bb5xmHfzKd1MNG63Sw3qQ9O0HPfiAcO379V+m5/v2yIfTOcHyIYjNFsIwncf8m2NLdq/bGVw/9pqabGw6G+lKZ05p7wJKp03ki15XCAuEMZMvfh/Q5LrRggZ2q8viZG4XPDCAd3qKNoSsHS3749bVXpEMtvjklxDV554LJiBHlWGn8H2oRG1bXWNaQMpxNGAFb+dfWVquobAjjoGHRMMUtX0guJFZHtw==',
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVAFmTfUXaE00stHZe7hst+ZwWe1bM3UaHlNhufgf1xYU0VVouoGaSknQmTd1+21MgGkAfkc45YrkqfYsCYG9sGALohJYBPEyh1RMObYgFYImvKtTXOvTMJ/HOErPcVNoeuwo9fic5Yred+o12HZaSmztG9W9ouACOXwjDTYP81vOj7gzZvqrjd1iV+mac/FOrFSYYR4EQCulsYVxfWWwCUd+kHsRh8gn6L5Wwkx5paORl/h7Rs1sh2xXtBx523zIrp4LoFhjM+uBxf5Om9igEVdWotYE10NvvXAfwFYbsSpWekdLtki0hQVz+lZmzRERP88GCSh3zvC8YFsOTbEzz'
    ]
  },
  {
    'id' => 'dan',
    'shell' => '/bin/zsh',
    'ssh_keys' => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyEerYBAUgrvmwfc3602oo3WVQbnEIam4vig6ah8YXUfpp1aatedEibcdvQCd5DYHrLFPDDeULF2IsJNh+hVTh1Pxj2Z4W1H+U/tXZt2eMeTX+MgAfREecL4dNcbRgDR1SuitfbsKv8zc5a+SZUYBaIAZvBIC5MJs2DMhYr3GQksIW8C2rROpowKP1Lj38IwSkvLZRvjIpT7diSctpJbiQV6Oh3MG949KUOdsb6RhjO1P+PIS03xds8+F8CfFLdw37bfAXNVEaijQcgG19a0tRivPpXFcem6Z9/PJF7ccjY1uJ7pQNkeLGI2Kx91rA/msAakulm40CQVg+aVn3oNU1'
    ]
  },
  {
    'id' => 'konstantin',
    'shell' => '/bin/zsh',
    'ssh_keys' => [
      'ssh-dss AAAAB3NzaC1kc3MAAACBANzKaTTWD/71M+YiVK1ngyTEm870H1e3YjJfDCsboEAvpj/2F7LJVrVeOPYSYjE9KqhhEFrzhT/O969OggIiHp3dQQfGKnIZFCuDuIfrtsR47UrHkW+CWPrUCy/A0+tUhmTEMpWjjaciQdXDFhcsrtKK6XXMd4oVzVYWflWNEriXAAAAFQCuDEU27P8qZK+Vv61vOKuX/hTNrwAAAIEAu3IIRr/tTvJyyDztw7GBAcI1cgU3AX8DfkRV/Qk/AqCOMy3CCQKdG0+yeL9zCpoPIUxNIp0wv18zY+XxoHAj8D5+AfPd6tIAzMuupYdOPP3OARUKV7zzho+r0M0mEc2JewLbCGkjEbW3KTsVQ/RxUu/DBjJ7PZrVHhEnObcF7vsAAACBANljUUgZTXCr6hfqXbA1+V/o1dQOr9OZR0aFIIuDC4QPLZRZVHq62hqNNy9DupGG76UfhWtUQ3xa6V0uDNU3FHAuWD1MIBPd/+/dTBG5EotlYGHO6zhDt0rtPQ7wPTOJUipjRNC1Q0nT06qMUz//J+6B0Am2KtBysi6MW+rNUQ+v',
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3iH0fyXZ3utXulMYcTCadVLYO1NC4m6DtPvjpMOZJfgbACeoxiRbtktAq700lvZipuvVoZaNWUVY3NIuu/YdKEP4DAWbgY8qnIUYCoEmul0rVuP0pGmV+sAEPBVL3yKxVJsEQyUjmvHBuSX8BiQ/SLX6bjk31BbimSGk6/+Zqw6HtNOl64OP42/weOgyOwq5htq3YGZhwUmSP6LEaREce1/fM1ivVnvnlMpzBDE8zuuK74AIKm7l51nfcQMDJmKMngji6HDVWavX92HNlvBfdQSy+Hk+mAC3rhyygNG5YWlpm4rJK3y0vZdsDVIvYjecDViWZsx7553/icNsZ7jxt'
    ]
  },
  {
    'id' => 'mathias',
    'shell' => '/bin/zsh',
    'ssh_keys' => [
      'ssh-dss AAAAB3NzaC1kc3MAAAEBAKarvjEyNwS1cUMzrBVoFZFoN/KqbQy8AmEezKXvuH7h7gN1lMx/0Kh34XBCFN80bXwOyh8yYeqr0WI8KGiIdJ+vgza99jBUj9EqMdk4IIzM6FBA3Z5V5oUzx2CyLZDDHMFVn5HjFjLSU7TFmx+BpEaN1aKm80WU8YD3ZCHnyo/7+IIAubGGo2b9CiKqbxTMBXvE/zr15h5/pY/ClUbexqqGKWGg1LHdX2hmMOqajkVyf6u56x2x9r/I7oZ3e6PlF1WisC38xaRWX2oS8+OAneYG4uf4cfiFQZ7rYz14wwbfGq8PhUA6Yequ2ifVZnctQXZmoWD5a9z2uEc+S22usf8AAAAVAIpmkTrmrvixN97zy8+R1oMvzTGrAAABADwFKfTLNS3P6/BBPTbrWTyC/7EQCt6ov/HQCWEMGCnArN3yg+Uu2pv2gHn5bhZIS3BvdSCSTI2P8IR7z7ykFrJd8T/iQZ4m7qOin1DJuiFaG6YX0vlvnQ9cehi2qaC26i36Y9jaZKGJo/DBWhK9NelcWZQNMGvAolzlyMfE9x9Dj73bdQx3HAYGxP7AlwKQVxPctz3jTUrtHc4pjq3tRIigJdY2Eh9LaUsybjMAA5wke3RvaWCbimQZHZiwg74jGPPqlgYAaRquR3p4/Dad4HQqT/N+HH5ZYOowSVZPz+jynTZfBC22UTQVd8FsAZApb33Hz1gAXtSarUBAzsqq7SIAAAEBAKL0em4WaXw035WfBW51Gqqs++y0dkULZcV9TlfptRq7aT9EW0eVJPAU/z1q7kkwB0kOmYTrLuuauY3U+DdRSMWqtXaJet7otyHc/WeI4dzIu2Ix+kUgG06R9LWRItzHNNh3z6s9o11jpniM++sTxi95oy747r/NlS3uY+2f95rKKqXQDwPfEK3CDe3ZZHCygryzlQ7vY5G5SMnC4TA/ICvWNg6EBaLKB4tGHU40u/nySOVFfrBal0hF/rDBaXqiUoMKIZcyPcjl1zV44EWyxedXnmTBfLs4pa4+Dt73+NnPl/jH94aMEz+SJM1BiJN424gREA1tYI/5P9NM9P5oA48=',
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAsBozqPPv+FeFoR20zliJ674ZCoLFYvVlNBmSJCvCGY8Oou3HD+vgFNjs2DsG+7kLcjXCiqE5Vw3baSsbOefOTMNPPET5jzxcyNQCMbF2dwaz3/voL19bgx41ke/cYcJW36bifzOwuC3oWRbjFxmW3CPKTYWgkMMZXebsXAEXDZ9lYf6CWb+irQ22666gou9Wv7Attxs2k1GmfSNd3YuvibTbu09J938wiNRvoiRKQ4VgeWYEB6Rvjd4C5VOovD234DBNa+mpbXoQ5j7v8XvVa27ljupYg5VOD1DaueiN/zJ7c0YIH64NjghanI6aJ70ByaKJq32D2ChlCYmVOVN78w==',
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEA9HNVAEyYi3HM8MAGQQBAKcSdedKTq46I/8MBb8h55hMsCXabaeBnxifnUTQO6468D+/9AuqVVNIfPAC4gkgWnwOn0CgROIUBwsx4A1F90j+C++8GU4U/NkL++VFD98BE928R+0ipc0DlUD6ohdjlCCjdsM+zedVnWtQJlS5X31E=',
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdKblbr7TP7/c3FqVYnnlqLRkSmTGxpuf3ju9nF96llEbQ9Wh4mCagE7968ROS0BjWQtGMQQKii3siPl17/f23uOCARJJV+mTdc0JN8riRwbkwRHvV/s5i7fpMnLyQMO5UceG3sTpemAL53q67RHZ9uP6uo6o/BfMkNNPreIu3QZBmNFF1AiykuqGnkabmiGj8OyIKnrvLNotIEmIic4TlAzg0eDRd88QQo3q6rFWXSRm88us6Qy8Of81sToMC36BJFxd+ln06DexThJcNtzv7HHQ8/5h3R4G2QRSCdGlEeAP9CN6ko+eBPRMla8mKL9XAEKvQvIu/s4ZYKKfNx1it'
    ]
  },
  {
    'id' => 'brandon',
    'shell' => '/bin/zsh',
    'ssh_keys' => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAxWuTBCVNg8OOTibpUpxIQsmO8ZWfhEbo3gTXSzg91rL3hp8U8BYJtdtaDxPIb4uqVntnTm38jylEHf3SAdnxTXoDhceSBBe5bDmtOQCNLu1HlBlauQd0temV92gA1LnjGLcrz23l/RBJj+jcAYhErqwjy+ffDIip1ltGB9mJoHe9yuICCwaq3BXv8jZ0yOEFM16kWrZXOuqOIU83LdgnPj1tj1DbXg++ax/Yb7ENgOjH/DlHJ1vDy/i2C29ZSa+PptPkXLOKeGa20zCJeMQ4wYwrK4t1Jiyaui4XHe8j4B0FfyM+z2lAjdqn1iuGT4AYx+tFq5/88OM66rclWRZkYmUSX3C7w4U7Rgyj/hIkl0UTHfPiSFiiJ9L0jwvHq6erbdLKX/aD/yCvhv4VJ9bBFgVVhSXciNJgQOAzGd+gUBJVZqr/DZby51U4JuR8dy11KtoH0S3nzBggYbekWNFKcEzSdmuVaZgC9Q+B59Gu850+gv8YH/9ysOmbRHbOiRmTdUnY3slqu+QRgIpun2xqvV9Fc1YWvV2ioEWCfpH0z0ImasZh55TCuDpicRtUiR3I8uwn46EoxqNkQqX5mm+k/ers03q3rRar2PzpEF6G3F+4bJKv+mbfx+BtKS6K6ZjSQzsc2E+RUNeyuaJEeytjYvrDpxkwGAF1vr5wHiQInFE='
    ]
  },
  {
    'id' => 'sven',
    'shell' => '/bin/zsh',
    'ssh_keys' => [
      'ssh-dss AAAAB3NzaC1kc3MAAACBAKLIhJ+nqHaXEOUSQjffMFek0ZZxOoJtrdAuXo14ISMD0YgEeBpjoCUFiejNUIi/3sp+xhxhgOG63Dzuo6SrRb1DkVppOSOX5Piw7mAkcPvOJAVPqKLOAFNZePtosDCO1jEnu/RBxBOc17CdNKpcgKuloVNf27Abahq0aBhk4RTFAAAAFQCQM+6Ny1024esdLmb7HSdE16G9fQAAAIAMQWuOopEld1gHxBLmOvVVP/2hjJcDp+JzO7VaTgBT1ryrDB/bm2RYzN2Qr+E0EKeupLRjpKA5scshN3H7hnffaWFyj01Xxajj/9lFqGG8pZ9s7vhqNK+bzxhzzKf9E438XT3ANR/6Tv/KE/+PQQ6mIemvC99E3Sl9y5zYH7PZCQAAAIAxLqibXcN0r2HS7wZ5cHreXKm4pkf4LVzj0SdqPjoRglxnqP5cVto/bwPYEf630zT9IuMeksEAz8lSKTeqgZAkiOmmiFy5JRtZfeHhNTAH1Q5syTkegbk0EmRkp5EIBuUmc81e6XwD2RTsaVOvkPpHPt7bmpWMXiJVxX0P9wcwUA=='
    ]
  }
]

override['authorization']['sudo']['users'] = override['users'].map { |u| u['id'] }
override['authorization']['sudo']['passwordless'] = 'true'
