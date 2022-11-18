alias forcefipsadhoc="bk build create --pipeline=chef/chef-chef-main-omnibus-adhoc --env='OMNIBUS_FILTER=\"*windows*\"
OMNIBUS_SOFTWARE_GITHUB_BRANCH=\"tp/INFC-289-final\"' --branch \`git branch --show-current\`"

function refreshfipstroubleshooting() {
  pushd ~/projects/openssl-1.0.2zb
  git diff > ~/projects/omnibus-software/config/patches/openssl/openssl-1.0.1j-windows-relocate-dll.patch
  popd
#  pushd ~/projects/fips_research/openssl-fips-2.0.16
#  git diff > ~/projects/omnibus-software/config/patches/openssl-fips/openssl-fips-debug-fingerprint.patch
#  popd
  pushd ~/projects/omnibus-software
  git add .
  git commit -m $1
  git push
  popd
  pushd ~chef
  forcefipsadhoc
  popd
}
