#!/bin/bash

WINE_VERSION=7.0
WINE_DOWNLOAD_URL="https://dl.winehq.org/wine/source/7.0/wine-${WINE_VERSION}.tar.xz"
BUILD_DIR="wine-${WINE_VERSION}"
PATCHES=("rpath.patch" "winemenubuilder.patch" "ws2siobacklogquery.patch" "wine-mr-1034.patch")

# Download build deps
sudo apt-get install -y --no-install-recommends \
					build-essential \
					gcc-multilib \
					checkinstall \
          patch \
          autoconf \
          automake \
          bison \
          flex \
          libgnutls28-dev \
          libxi-dev \
          gcc-mingw-w64 \
          binutils-mingw-w64 \
          linux-headers-$(uname -r)

# Download & unpack wine source
curl "$WINE_DOWNLOAD_URL" --output wine-$WINE_VERSION.tar.xz
tar -xf wine-$WINE_VERSION.tar.xz

cd $BUILD_DIR

# Apply patches
for patch_name in ${PATCHES[@]}; do
  patch -p1 < ../$patch_name
done

# Configure wine
_win64=""
_no_pie=""
case "$(uname -m)" in
		x86_64) _win64=--enable-win64;;
		x86) _no_pie="-no-pie";;
esac

./configure \
		--build=$CBUILD \
		--host=$CHOST \
		--prefix=/usr \
		--libdir=/usr/lib \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--without-alsa \
		--without-capi \
		--without-coreaudio \
		--without-cups \
		--without-dbus \
		--without-fontconfig \
		--without-freetype \
		--without-gettext \
		--with-gnutls \
		--without-gphoto \
		--without-gssapi \
		--without-gstreamer \
		--without-inotify \
		--without-krb5 \
		--without-ldap \
		--with-mingw \
		--without-netapi \
		--without-openal \
		--without-opencl \
		--without-opengl \
		--without-osmesa \
		--without-oss \
		--without-pcap \
		--without-pulse \
		--without-sane \
		--without-sdl \
		--without-udev \
		--without-usb \
		--without-v4l2 \
		--without-vkd3d \
		--without-vulkan \
		--with-x \
		--without-xcomposite \
		--without-xcursor \
		--without-xfixes \
		--without-xinerama \
		--without-xinput \
		--with-xinput2 \
		--without-xrandr \
		--without-xrender \
		--without-xshape \
		--without-xshm \
		--without-xxf86vm \
		$_win64 \
		\
		--disable-tests --disable-notepad --disable-msxml --disable-msxml2 --disable-msxml3 --disable-msxml4 \
		--disable-msxml5 --disable-msxml6 --disable-msado15 --disable-msadp32 --disable-msdaps --disable-msdasql \
		--disable-quartz --disable-sapi --disable-scsiport --disable-usbd --disable-wineps_drv --disable-winspool_drv \
		--disable-mp3dmod --disable-l3codeca --disable-winedbg \
		\
		--without-xml --without-xslt \
		--disable-xml2 --disable-xslt \
		\
		--disable-arp --disable-aspnet_regiis --disable-attrib --disable-cabarc --disable-cacls --disable-chcp_com --disable-clock --disable-control \
		--disable-cscript --disable-dism --disable-dplaysvr --disable-dpnsvr --disable-dpvsetup --disable-dxdiag --disable-eject --disable-expand \
		--disable-extrac32 --disable-fc --disable-find --disable-findstr --disable-fsutil --disable-hostname --disable-icacls --disable-icinfo \
		--disable-iexplore --disable-ipconfig --disable-lodctr --disable-mshta --disable-msidb --disable-msiexec --disable-msinfo32 --disable-net \
		--disable-netsh --disable-netstat --disable-ngen --disable-oleview --disable-ping --disable-powershell --disable-presentationfontcache \
		--disable-progman --disable-robocopy --disable-sc --disable-schtasks --disable-sdbinst --disable-secedit --disable-servicemodelreg --disable-shutdown \
		--disable-spoolsv --disable-subst --disable-systeminfo --disable-taskmgr --disable-termsv --disable-uninstaller --disable-unlodctr --disable-view \
		--disable-wevtutil --disable-where --disable-whoami --disable-winebrowser --disable-wineconsole --disable-winefile --disable-winemenubuilder \
		--disable-winemine --disable-winemsibuilder --disable-winetest --disable-winhlp32 --disable-winmgmt --disable-winver --disable-wmplayer \
		--disable-wordpad --disable-write --disable-wscript --disable-wuauserv --disable-wusa --disable-xcopy --disable-acledit --disable-aclui \
		--disable-adsldp --disable-adsldpc --disable-amsi --disable-amstream --disable-api_ms_win_appmodel_identity_l1_1_0 \
		--disable-api_ms_win_appmodel_runtime_l1_1_0 --disable-api_ms_win_appmodel_runtime_l1_1_1 --disable-api_ms_win_appmodel_runtime_l1_1_2 \
		--disable-api_ms_win_crt_conio_l1_1_0 --disable-api_ms_win_crt_multibyte_l1_1_0 --disable-api_ms_win_crt_private_l1_1_0 \
		--disable-api_ms_win_crt_process_l1_1_0 --disable-api_ms_win_devices_config_l1_1_0 --disable-api_ms_win_devices_config_l1_1_1 \
		--disable-api_ms_win_devices_query_l1_1_1 --disable-api_ms_win_downlevel_advapi32_l1_1_0 --disable-api_ms_win_downlevel_advapi32_l2_1_0 \
		--disable-api_ms_win_downlevel_kernel32_l2_1_0 --disable-api_ms_win_downlevel_normaliz_l1_1_0 --disable-api_ms_win_downlevel_ole32_l1_1_0 \
		--disable-api_ms_win_downlevel_shell32_l1_1_0 --disable-api_ms_win_downlevel_shlwapi_l1_1_0 --disable-api_ms_win_downlevel_shlwapi_l2_1_0 \
		--disable-api_ms_win_downlevel_user32_l1_1_0 --disable-api_ms_win_downlevel_version_l1_1_0 --disable-api_ms_win_dx_d3dkmt_l1_1_0 \
		--disable-api_ms_win_eventing_classicprovider_l1_1_0 --disable-api_ms_win_eventing_consumer_l1_1_0 --disable-api_ms_win_eventing_controller_l1_1_0 \
		--disable-api_ms_win_eventing_legacy_l1_1_0 --disable-api_ms_win_eventing_provider_l1_1_0 --disable-api_ms_win_eventlog_legacy_l1_1_0 \
		--disable-api_ms_win_gaming_tcui_l1_1_0 --disable-api_ms_win_gdi_dpiinfo_l1_1_0 --disable-api_ms_win_mm_joystick_l1_1_0 \
		--disable-api_ms_win_mm_misc_l1_1_1 --disable-api_ms_win_mm_mme_l1_1_0 --disable-api_ms_win_mm_time_l1_1_0 \
		--disable-api_ms_win_ntuser_dc_access_l1_1_0 --disable-api_ms_win_ntuser_rectangle_l1_1_0 --disable-api_ms_win_ntuser_sysparams_l1_1_0 \
		--disable-api_ms_win_perf_legacy_l1_1_0 --disable-api_ms_win_power_base_l1_1_0 --disable-api_ms_win_power_setting_l1_1_0 \
		--disable-api_ms_win_rtcore_ntuser_draw_l1_1_0 --disable-api_ms_win_rtcore_ntuser_private_l1_1_0 --disable-api_ms_win_rtcore_ntuser_private_l1_1_4 \
		--disable-api_ms_win_rtcore_ntuser_window_l1_1_0 --disable-api_ms_win_rtcore_ntuser_winevent_l1_1_0 \
		--disable-api_ms_win_rtcore_ntuser_wmpointer_l1_1_0 --disable-api_ms_win_rtcore_ntuser_wmpointer_l1_1_3 \
		--disable-api_ms_win_security_activedirectoryclient_l1_1_0 --disable-api_ms_win_security_audit_l1_1_1 --disable-api_ms_win_security_base_l1_1_0 \
		--disable-api_ms_win_security_base_l1_2_0 --disable-api_ms_win_security_base_private_l1_1_1 --disable-api_ms_win_security_credentials_l1_1_0 \
		--disable-api_ms_win_security_cryptoapi_l1_1_0 --disable-api_ms_win_security_grouppolicy_l1_1_0 --disable-api_ms_win_security_lsalookup_l1_1_0 \
		--disable-api_ms_win_security_lsalookup_l1_1_1 --disable-api_ms_win_security_lsalookup_l2_1_0 --disable-api_ms_win_security_lsalookup_l2_1_1 \
		--disable-api_ms_win_security_lsapolicy_l1_1_0 --disable-api_ms_win_security_provider_l1_1_0 --disable-api_ms_win_security_sddl_l1_1_0 \
		--disable-api_ms_win_security_systemfunctions_l1_1_0 --disable-api_ms_win_service_core_l1_1_0 --disable-api_ms_win_service_core_l1_1_1 \
		--disable-api_ms_win_service_management_l1_1_0 --disable-api_ms_win_service_management_l2_1_0 --disable-api_ms_win_service_private_l1_1_1 \
		--disable-api_ms_win_service_winsvc_l1_1_0 --disable-api_ms_win_service_winsvc_l1_2_0 --disable-api_ms_win_shcore_obsolete_l1_1_0 \
		--disable-api_ms_win_shcore_scaling_l1_1_0 --disable-api_ms_win_shcore_scaling_l1_1_1 --disable-api_ms_win_shcore_stream_l1_1_0 \
		--disable-api_ms_win_shcore_stream_winrt_l1_1_0 --disable-api_ms_win_shcore_thread_l1_1_0 --disable-api_ms_win_shell_shellcom_l1_1_0 \
		--disable-api_ms_win_shell_shellfolders_l1_1_0 --disable-apphelp --disable-appwiz_cpl --disable-atl --disable-atl110 --disable-atl80 --disable-atl90 \
		--disable-atlthunk --disable-atmlib --disable-authz --disable-avrt --disable-bluetoothapis --disable-browseui --disable-bthprops_cpl \
		--disable-cabinet --disable-capi2032 --disable-cards --disable-cdosys --disable-cfgmgr32 --disable-clusapi --disable-comcat --disable-compstui \
		--disable-comsvcs --disable-connect --disable-credui --disable-crtdll --disable-cryptdll --disable-cryptext --disable-cryptsp --disable-ctapi32 \
		--disable-ctl3d32 --disable-d2d1 --disable-d3d10 --disable-d3d10_1 --disable-d3d10core --disable-d3d11 --disable-d3d12 --disable-d3d8 \
		--disable-d3d8thk --disable-d3d9 --disable-d3dcompiler_33 --disable-d3dcompiler_34 --disable-d3dcompiler_35 --disable-d3dcompiler_36 \
		--disable-d3dcompiler_37 --disable-d3dcompiler_38 --disable-d3dcompiler_39 --disable-d3dcompiler_40 --disable-d3dcompiler_41 --disable-d3dcompiler_42 \
		--disable-d3dcompiler_43 --disable-d3dcompiler_46 --disable-d3dcompiler_47 --disable-d3dim --disable-d3dim700 --disable-d3drm --disable-d3dx10_33 \
		--disable-d3dx10_34 --disable-d3dx10_35 --disable-d3dx10_36 --disable-d3dx10_37 --disable-d3dx10_38 --disable-d3dx10_39 --disable-d3dx10_40 \
		--disable-d3dx10_41 --disable-d3dx10_42 --disable-d3dx10_43 --disable-d3dx11_42 --disable-d3dx11_43 --disable-d3dx9_24 --disable-d3dx9_25 \
		--disable-d3dx9_26 --disable-d3dx9_27 --disable-d3dx9_28 --disable-d3dx9_29 --disable-d3dx9_30 --disable-d3dx9_31 --disable-d3dx9_32 \
		--disable-d3dx9_33 --disable-d3dx9_34 --disable-d3dx9_35 --disable-d3dx9_36 --disable-d3dx9_37 --disable-d3dx9_38 --disable-d3dx9_39 \
		--disable-d3dx9_40 --disable-d3dx9_41 --disable-d3dx9_42 --disable-d3dx9_43 --disable-d3dxof --disable-davclnt --disable-dbgeng --disable-dciman32 \
		--disable-dcomp --disable-ddraw --disable-ddrawex --disable-dhcpcsvc --disable-dhcpcsvc6 --disable-dhtmled_ocx --disable-difxapi --disable-dinput \
		--disable-dinput8 --disable-directmanipulation --disable-dispex --disable-dmband --disable-dmcompos --disable-dmime --disable-dmloader \
		--disable-dmscript --disable-dmstyle --disable-dmsynth --disable-dmusic --disable-dmusic32 --disable-dplay --disable-dplayx --disable-dpnaddr \
		--disable-dpnet --disable-dpnhpast --disable-dpnhupnp --disable-dpnlobby --disable-dpvoice --disable-dpwsockx --disable-drmclien --disable-dsdmo \
		--disable-dsquery --disable-dssenh --disable-dsuiext --disable-dswave --disable-dwmapi --disable-dwrite --disable-dx8vb --disable-dxdiagn \
		--disable-dxgi --disable-dxtrans --disable-dxva2 --disable-esent --disable-evr --disable-ext_ms_win_authz_context_l1_1_0 \
		--disable-ext_ms_win_domainjoin_netjoin_l1_1_0 --disable-ext_ms_win_dwmapi_ext_l1_1_0 --disable-ext_ms_win_gdi_dc_create_l1_1_0 \
		--disable-ext_ms_win_gdi_dc_create_l1_1_1 --disable-ext_ms_win_gdi_dc_l1_2_0 --disable-ext_ms_win_gdi_devcaps_l1_1_0 \
		--disable-ext_ms_win_gdi_draw_l1_1_0 --disable-ext_ms_win_gdi_draw_l1_1_1 --disable-ext_ms_win_gdi_font_l1_1_0 --disable-ext_ms_win_gdi_font_l1_1_1 \
		--disable-ext_ms_win_gdi_render_l1_1_0 --disable-ext_ms_win_kernel32_package_current_l1_1_0 --disable-ext_ms_win_kernel32_package_l1_1_1 \
		--disable-ext_ms_win_ntuser_dialogbox_l1_1_0 --disable-ext_ms_win_ntuser_draw_l1_1_0 --disable-ext_ms_win_ntuser_gui_l1_1_0 \
		--disable-ext_ms_win_ntuser_gui_l1_3_0 --disable-ext_ms_win_ntuser_keyboard_l1_3_0 --disable-ext_ms_win_ntuser_message_l1_1_0 \
		--disable-ext_ms_win_ntuser_message_l1_1_1 --disable-ext_ms_win_ntuser_misc_l1_1_0 --disable-ext_ms_win_ntuser_misc_l1_2_0 \
		--disable-ext_ms_win_ntuser_misc_l1_5_1 --disable-ext_ms_win_ntuser_mouse_l1_1_0 --disable-ext_ms_win_ntuser_private_l1_1_1 \
		--disable-ext_ms_win_ntuser_private_l1_3_1 --disable-ext_ms_win_ntuser_rectangle_ext_l1_1_0 --disable-ext_ms_win_ntuser_uicontext_ext_l1_1_0 \
		--disable-ext_ms_win_ntuser_windowclass_l1_1_0 --disable-ext_ms_win_ntuser_windowclass_l1_1_1 --disable-ext_ms_win_ntuser_window_l1_1_0 \
		--disable-ext_ms_win_ntuser_window_l1_1_1 --disable-ext_ms_win_ntuser_window_l1_1_4 --disable-ext_ms_win_oleacc_l1_1_0 \
		--disable-ext_ms_win_ras_rasapi32_l1_1_0 --disable-ext_ms_win_rtcore_gdi_devcaps_l1_1_0 --disable-ext_ms_win_rtcore_gdi_object_l1_1_0 \
		--disable-ext_ms_win_rtcore_gdi_rgn_l1_1_0 --disable-ext_ms_win_rtcore_ntuser_cursor_l1_1_0 --disable-ext_ms_win_rtcore_ntuser_dc_access_l1_1_0 \
		--disable-ext_ms_win_rtcore_ntuser_dpi_l1_1_0 --disable-ext_ms_win_rtcore_ntuser_dpi_l1_2_0 --disable-ext_ms_win_rtcore_ntuser_rawinput_l1_1_0 \
		--disable-ext_ms_win_rtcore_ntuser_syscolors_l1_1_0 --disable-ext_ms_win_rtcore_ntuser_sysparams_l1_1_0 --disable-ext_ms_win_security_credui_l1_1_0 \
		--disable-ext_ms_win_security_cryptui_l1_1_0 --disable-ext_ms_win_shell_comctl32_init_l1_1_0 --disable-ext_ms_win_shell_comdlg32_l1_1_0 \
		--disable-ext_ms_win_shell_shell32_l1_2_0 --disable-ext_ms_win_uxtheme_themes_l1_1_0 --disable-faultrep --disable-feclient --disable-fltlib \
		--disable-fntcache --disable-fontsub --disable-fusion --disable-fwpuclnt --disable-gameux --disable-gamingtcui --disable-gdiplus --disable-glu32 \
		--disable-gphoto2_ds --disable-gpkcsp --disable-hal --disable-hlink --disable-hnetcfg --disable-iccvid --disable-icmp --disable-ieframe \
		--disable-ieproxy --disable-imagehlp --disable-inetcomm --disable-inetcpl_cpl --disable-inetmib1 --disable-infosoft --disable-initpki \
		--disable-inkobj --disable-inseng --disable-iprop --disable-irprops_cpl --disable-itircl --disable-itss --disable-joy_cpl --disable-jscript \
		--disable-jsproxy --disable-ksproxy_ax --disable-ksuser --disable-ktmw32 --disable-loadperf --disable-localspl --disable-localui --disable-lz32 \
		--disable-mapi32 --disable-mapistub --disable-mciavi32 --disable-mcicda --disable-mciqtz32 --disable-mciseq --disable-mciwave --disable-mf \
		--disable-mf3216 --disable-mferror --disable-mfmediaengine --disable-mfplat --disable-mfplay --disable-mfreadwrite --disable-mgmtapi \
		--disable-midimap --disable-mmcndmgr --disable-msasn1 --disable-mscat32 --disable-mscms --disable-mscoree --disable-mscorwks --disable-msctf \
		--disable-msctfmonitor --disable-msctfp --disable-msdelta --disable-msdrm --disable-msftedit --disable-mshtml --disable-mshtml_tlb --disable-msi \
		--disable-msident --disable-msimg32 --disable-msimsg --disable-msimtf --disable-msisys_ocx --disable-msls31 --disable-msnet32 --disable-mspatcha \
		--disable-msports --disable-msrle32 --disable-msscript_ocx --disable-mssign32 --disable-mssip32 --disable-mstask --disable-msvcirt --disable-msvcm80 \
		--disable-msvcm90 --disable-msvcp100 --disable-msvcp120 --disable-msvcp120_app --disable-msvcp60 --disable-msvcp70 --disable-msvcp71 \
		--disable-msvcp80 --disable-msvcp90 --disable-msvcp_win --disable-msvcr100 --disable-msvcr120 --disable-msvcr120_app --disable-msvcr70 \
		--disable-msvcr71 --disable-msvcr80 --disable-msvcr90 --disable-msvidc32 --disable-mswsock --disable-mtxdm --disable-ncrypt --disable-nddeapi \
		--disable-netcfgx --disable-netprofm --disable-netutils --disable-ninput --disable-npmshtml --disable-npptools --disable-ntdsapi --disable-ntprint \
		--disable-objsel --disable-odbc32 --disable-odbcbcp --disable-odbccp32 --disable-odbccu32 --disable-oleacc --disable-olecli32 --disable-oledlg \
		--disable-olepro32 --disable-olesvr32 --disable-olethk32 --disable-opcservices --disable-openal32 --disable-opencl --disable-packager --disable-pdh \
		--disable-photometadatahandler --disable-pidgen --disable-powrprof --disable-printui --disable-prntvpt --disable-pstorec --disable-pwrshplugin \
		--disable-qasf --disable-qdvd --disable-qmgr --disable-qmgrprxy --disable-query --disable-qwave --disable-rasapi32 --disable-rasdlg \
		--disable-resutils --disable-riched20 --disable-riched32 --disable-rsabase --disable-rstrtmgr --disable-rtutils --disable-rtworkq --disable-samlib \
		--disable-sane_ds --disable-sas --disable-scarddlg --disable-sccbase --disable-schedsvc --disable-scrobj --disable-scrrun --disable-security \
		--disable-sensapi --disable-serialui --disable-sfc --disable-sfc_os --disable-shdoclc --disable-shfolder --disable-slbcsp --disable-slc \
		--disable-snmpapi --disable-softpub --disable-spoolss --disable-sppc --disable-srclient --disable-srvcli --disable-sspicli --disable-stdole2_tlb \
		--disable-stdole32_tlb --disable-sti --disable-strmdll --disable-svrapi --disable-sxs --disable-t2embed --disable-tapi32 --disable-taskschd \
		--disable-tbs --disable-tdh --disable-traffic --disable-twain_32 --disable-uianimation --disable-uiautomationcore --disable-uiribbon \
		--disable-unicows --disable-updspapi --disable-url --disable-usp10 --disable-utildll --disable-vbscript --disable-vcomp --disable-vcomp100 \
		--disable-vcomp110 --disable-vcomp120 --disable-vcomp140 --disable-vcomp90 --disable-vdmdbg --disable-vga --disable-virtdisk --disable-vssapi \
		--disable-vulkan_1 --disable-wdscore --disable-webservices --disable-websocket --disable-wer --disable-wevtapi --disable-wiaservc --disable-wimgapi \
		--disable-winealsa_drv --disable-wineandroid_drv --disable-winecoreaudio_drv --disable-wined3d --disable-winegstreamer --disable-winemac_drv \
		--disable-winemapi --disable-wineoss_drv --disable-winepulse_drv --disable-wineusb_sys --disable-wing32 --disable-winhttp --disable-winnls32 \
		--disable-winscard --disable-winsta --disable-wintab32 --disable-winusb --disable-wlanapi --disable-wlanui --disable-wmasf --disable-wmi \
		--disable-wmp --disable-wmphoto --disable-wmvcore --disable-wnaspi32 --disable-wow64 --disable-wow64cpu --disable-wow64win --disable-wpc \
		--disable-wpcap --disable-wsdapi --disable-wshom_ocx --disable-wsnmp32 --disable-wtsapi32 --disable-wuapi --disable-wuaueng --disable-x3daudio1_0 \
		--disable-x3daudio1_1 --disable-x3daudio1_2 --disable-x3daudio1_3 --disable-x3daudio1_4 --disable-x3daudio1_5 --disable-x3daudio1_6 \
		--disable-x3daudio1_7 --disable-xactengine2_0 --disable-xactengine2_4 --disable-xactengine2_7 --disable-xactengine2_9 --disable-xactengine3_0 \
		--disable-xactengine3_1 --disable-xactengine3_2 --disable-xactengine3_3 --disable-xactengine3_4 --disable-xactengine3_5 --disable-xactengine3_6 \
		--disable-xactengine3_7 --disable-xapofx1_1 --disable-xapofx1_2 --disable-xapofx1_3 --disable-xapofx1_4 --disable-xapofx1_5 --disable-xaudio2_0 \
		--disable-xaudio2_1 --disable-xaudio2_2 --disable-xaudio2_3 --disable-xaudio2_4 --disable-xaudio2_5 --disable-xaudio2_6 --disable-xaudio2_7 \
		--disable-xaudio2_8 --disable-xaudio2_9 --disable-xinput1_1 --disable-xinput1_2 --disable-xinput1_4 --disable-xmllite --disable-xolehlp \
		--disable-xpsprint --disable-xpssvcs

# Build wine
make LDFLAGS="$LDFLAGS $_no_pie" \
		tools/widl/widl \
		tools/winebuild/winebuild \
		tools/widl/widl \
		tools/winebuild/winebuild \
		tools/winegcc/winegcc \
		tools/wrc/wrc
make

# Pack wine
sudo checkinstall -D --install=no --default