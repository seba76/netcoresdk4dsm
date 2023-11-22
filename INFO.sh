# INFO.sh
#[ -f /pkgscripts/include/pkg_util.sh ] && . /pkgscripts/include/pkg_util.sh
#[ -f /pkgscripts-ng/include/pkg_util.sh ] && . /pkgscripts-ng/include/pkg_util.sh 

source /pkgscripts-ng/include/pkg_util.sh

package="netcoresdk4dsm"
displayname=".NET Core SDK 8.0.100"
version="8.0.100"
#os_min_ver="$1"
os_min_ver="7.0-40000"
description="The .NET Core SDK enables you to build and run .NET applications."
arch="x86_64"
#arch="$(pkg_get_platform_family)"
#arch="$(pkg_get_unified_platform)"
maintainer="seba"
maintainer_url="http://github.com/seba76/"
distributor="seba"
report_url="https://github.com/seba76/netcoresdk4dsm/"
support_url="https://github.com/seba76/netcoresdk4dsm/"
thirdparty="yes"
reloadui="no"
startable="no"
install_conflict_packages="aspnetcore4dsm"
[ "$(caller)" != "0 NULL" ] && return 0
pkg_dump_info
