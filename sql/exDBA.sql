CREATE TABLE public.virt_manager_data (
	_key varchar(32) NULL DEFAULT NULL::character varying,
	host varchar(128) NULL DEFAULT NULL::character varying,
	vm_proc_id int4 NOT NULL DEFAULT 0,
	vm_name varchar(256) NULL DEFAULT NULL::character varying,
	cpu_total int4 NOT NULL DEFAULT 0,
	cpu_usage int4 NOT NULL DEFAULT 0,

	clock int4 NOT NULL DEFAULT 0
);




CREATE TABLE backbone_host_ports (
  hostname varchar(128) NULL DEFAULT NULL::character varying,
  hostaddr varchar(128) NULL DEFAULT NULL::character varying,
  adminstatus int4 NOT NULL DEFAULT 0);
  operstatus int4 NOT NULL DEFAULT 0);
  clock  int4 NOT NULL DEFAULT 0);
CREATE INDEX backbone_host_ports_1 ON public.backbone_host_ports USING btree (hostname, hostaddr, clock);



CREATE TABLE backbone_host_location (
  hostname varchar(128) NULL DEFAULT NULL::character varying,
  hostaddr varchar(128) NULL DEFAULT NULL::character varying,
  location varchar(256) NULL DEFAULT NULL::character varying,
  clock int4 NOT NULL DEFAULT 0);
CREATE INDEX backbone_host_location_1 ON public.backbone_host_location USING btree (hostname, hostaddr, clock);

CREATE TABLE backbone_link (
  hostname_a varchar(128) NULL DEFAULT NULL::character varying,
  hostname_b varchar(128) NULL DEFAULT NULL::character varying,
  link_type varchar(64) NULL DEFAULT NULL::character varying,
  clock int4 NOT NULL DEFAULT 0);
CREATE INDEX backbone_link_1 ON public.backbone_link USING btree (hostname_a, hostname_b, clock);

CREATE TABLE backbone_status (
  hostname varchar(128) NULL DEFAULT NULL::character varying,
  hostaddr varchar(128) NULL DEFAULT NULL::character varying,
  ifTotalInOctets numeric(20) NOT NULL DEFAULT '0'::numeric,
  ifTotalOutOctets numeric(20) NOT NULL DEFAULT '0'::numeric,
  ifTotalErrors numeric(20) NOT NULL DEFAULT '0'::numeric,
  ifTotalDiscards numeric(20) NOT NULL DEFAULT '0'::numeric,
  ifUpPorts int4 NULL DEFAULT 0,
  ifDownPorts int4 NULL DEFAULT 0,
  ifPort40G int4 NULL DEFAULT 0,
  ifPort10G int4 NULL DEFAULT 0,
  ifPort1G int4 NULL DEFAULT 0,
  ifPort100M int4 NULL DEFAULT 0,
  clock int4 NOT NULL DEFAULT 0
);
CREATE INDEX backbone_status_1 ON public.backbone_status_interfaces USING btree (hostname, hostaddr, clock);

echo "SELECT create_hypertable('backbone_status', 'clock', chunk_time_interval => 86400, migrate_data => true);" | psql backbone_manager


CREATE TABLE public.backbone_status_interfaces (
	hostname varchar(128) NULL DEFAULT NULL::character varying,
	hostaddr varchar(128) NULL DEFAULT NULL::character varying,
	ifindex int4 NULL DEFAULT 0,
	ifdescr varchar(128) NULL DEFAULT NULL::character varying,
	ifalias varchar(128) NULL DEFAULT NULL::character varying,
	iftype int4 NULL DEFAULT 0,
	ifadminstatus int4 NULL DEFAULT 0,
	ifoperstatus int4 NULL DEFAULT 0,
	ifspeed numeric(20) NOT NULL DEFAULT '0'::numeric,
	iftotalinoctets numeric(20) NOT NULL DEFAULT '0'::numeric,
	iftotaloutoctets numeric(20) NOT NULL DEFAULT '0'::numeric,
	clock int4 NOT NULL DEFAULT 0
);
CREATE INDEX backbone_status_interfaces_1 ON public.backbone_status_interfaces USING btree (hostname, ifindex, clock);

CREATE INDEX backbone_status_interfaces_clock_idx ON public.backbone_status_interfaces USING btree (clock DESC);
echo "SELECT create_hypertable('backbone_status_interfaces', 'clock', chunk_time_interval => 86400, migrate_data => true);" | psql backbone_manager
