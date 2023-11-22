#!/bin/bash

#defaults
DownloadURL=https://download.visualstudio.microsoft.com/download/pr/5226a5fa-8c0b-474f-b79a-8984ad7c5beb/3113ccbf789c9fd29972835f0f334b7a/dotnet-sdk-8.0.100-linux-x64.tar.gz
Version=8.0.100
DotNetFile=dotnet-sdk-${Version}-linux-x64.tar.gz

DSM_PLAT=bromolow
DSM_BUILD_VER=7.2

WGET=$(which wget)
UNZIP=$(which unzip)

if [ "$WGET" == "" ]; then
  WGET=./wget
fi

if [ "$UNZIP" == "" ]; then
  UNZIP="./unzip"
fi

function prompt_for_source()
{
	PS3='Please select version: '
	options=(".NET Core SDK 8.0" "Quit")
	select opt in "${options[@]}"
	do
		case $opt in
			".NET Core SDK 8.0")
				DownloadURL=https://download.visualstudio.microsoft.com/download/pr/5226a5fa-8c0b-474f-b79a-8984ad7c5beb/3113ccbf789c9fd29972835f0f334b7a/dotnet-sdk-8.0.100-linux-x64.tar.gz
				Version=8.0.100
				break
				;;
			"Quit")
				exit 1
				break
				;;
			*) echo "invalid option $REPLY";;
		esac
	done

	DotNetFile=dotnet-sdk-${Version}-linux-x64.tar.gz
}

function download_dotnet()
{
  if [ ! -f ./${DotNetFile} ]; then
	echo "Downloading runtime dist from dot.net"
	$WGET ${DownloadURL} -O ${DotNetFile}
	chmod 755 ${DotNetFile}
  fi
}

function update_info()
{
  echo "Update version in INFO.sh"
  sed -i -e "s|^version=.*|version=\"${Version}\"|g" INFO.sh
  sed -i -e "s|^displayname=.*|displayname=\".NET Core SDK ${Version}\"|g" INFO.sh
}

function extract()
{
  echo "Extracting ${DotNetFile}"
  [ ! -d package ] && mkdir package
  tar xf ${DotNetFile} -C package/
  [ ! -d package/wrapper ] && mkdir -p package/wrapper
  echo '#!/bin/sh' > package/wrapper/dotnet.sh
  echo 'export DOTNET_ROOT=/var/packages/netcoresdk4dsm/target' >> package/wrapper/dotnet.sh
  echo '/var/packages/netcoresdk4dsm/target/dotnet "$@"' >> package/wrapper/dotnet.sh
}

# get_key_value is in bin dir i.e. "get_key_value xfile key"
# set_key_value xfile key value
function set_key_value() {
	xfile="$1"
	param="$2"
	value="$3"
	grep -q "${param}" ${xfile} && \
		/bin/sed -i "s/^${param}.*/${param}=\"${value}\"/" ${xfile} || \
		echo "${param}=\"${value}\"" >> ${xfile}
}

case $1 in
  prep)
    prompt_for_source
    download_dotnet
    update_info
    extract
    echo "Ready to exec:"
    [ ! -d ../../build_env/ds.${DSM_PLAT}-${DSM_BUILD_VER} ] && echo "         'sudo ../../pkgscripts-ng/EnvDeploy -p ${DSM_PLAT} -v ${DSM_BUILD_VER}'"
    echo "         'sudo ../../pkgscripts-ng/PkgCreate.py --print-log -p ${DSM_PLAT} -v ${DSM_BUILD_VER} -c netcoresdk4dsm'"
  ;;
  clean)
    rm -rf package
  ;;
  cleanall)
    rm -rf package
    rm dotnet-sdk-*-linux-x64.tar.gz
  ;;
  *)
    echo "Usage: ./config.sh prep|clean|cleanall";
  ;;
esac
