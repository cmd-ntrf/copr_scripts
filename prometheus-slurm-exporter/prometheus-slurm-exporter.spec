%define        __spec_install_post %{nil}
%define          debug_package %{nil}
%define        __os_install_post %{_dbpath}/brp-compress

Name:           prometheus-slurm-exporter
Version:        0.21
Release:        1%{?dist}
Summary:        Prometheus exporter for SLURM metrics
Group:          Monitoring

License:        GPL 3.0
URL:            https://github.com/guilbaults/prometheus-slurm-exporter/tree/osc

Source:         prometheus-slurm-exporter-%{version}.tar.gz

BuildRequires: golang
BuildRoot:      %{_tmppath}/%{name}-%{version}-1-root

%description
A Prometheus exporter for metrics extracted from the Slurm resource scheduling system.

%prep
%setup -q -n %{name}-%{version}

%build
# Empty section.
go build

%install
rm -rf %{buildroot}
mkdir -vp %{buildroot}
mkdir -vp %{buildroot}/usr/bin
install -m 755 prometheus-slurm-exporter %{buildroot}/usr/bin/prometheus-slurm-exporter

%clean
rm -rf %{buildroot}

%pre

%post

%preun

%postun

%files
%defattr(-,root,root,-)
%{_bindir}/prometheus-slurm-exporter

%changelog
* Fri Jan 20 2023 Felix <felix@calculquebe.ca> - 0.21
- Remaster spec file to use go build