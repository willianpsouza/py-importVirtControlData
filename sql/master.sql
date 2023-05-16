create table virt_manager_data (
  _key varchar(32) NULL DEFAULT NULL::character varying,
  host varchar(128) NULL DEFAULT NULL::character varying,
  vm_proc_id int4 NOT NULL DEFAULT 0,
  vm_name varchar(256) NULL DEFAULT NULL::character varying,
  cpu_total int4 NOT NULL DEFAULT 0,
  cpu_usage int4 NOT NULL DEFAULT 0,
  memory_allocated int4 NOT NULL DEFAULT 0,
  host_memory_usage int4 NOT NULL DEFAULT 0,
  host_memory_peak int4 NOT NULL DEFAULT 0,
  host_memory_swap int4 NOT NULL DEFAULT 0,
  context_switch int4 NOT NULL DEFAULT 0,
  net_tx_pkts float8 DEFAULT NULL,
  net_rx_pkts float8 DEFAULT NULL,
  net_tx_bytes float8 DEFAULT NULL,
  net_rx_bytes float8 DEFAULT NULL,
  disk_total int4 NOT NULL DEFAULT 0,
  disk_read_reqs_sec float8 DEFAULT NULL,
  disk_write_reqs_sec float8 DEFAULT NULL,
  disk_read_bytes_sec float8 DEFAULT NULL,
  disk_write_bytes_sec float8 DEFAULT NULL,
  disk_physical int4 NOT NULL DEFAULT 0,
  disk_capacity int4 NOT NULL DEFAULT 0,
  sumarized char(1) DEFAULT '0',
  clock int4 NOT NULL DEFAULT 0
);
CREATE INDEX virt_manager_data_idx_001 ON public.virt_manager_data USING btree (clock DESC);
SELECT create_hypertable('virt_manager_data', 'clock', chunk_time_interval => 86400, migrate_data => true);


CREATE TABLE virt_manager_status (
  host varchar(128) NULL DEFAULT NULL::character varying,
  guest_total int4 NOT NULL DEFAULT 0,
  cpu_total int4 NOT NULL DEFAULT 0,
  cpu_usage int4 NOT NULL DEFAULT 0,
  context_switch int4 NOT NULL DEFAULT 0,
  memory_allocated int4 NOT NULL DEFAULT 0,
  host_memory_usage int4 NOT NULL DEFAULT 0,
  host_memory_peak int4 NOT NULL DEFAULT 0,
  host_memory_swap int4 NOT NULL DEFAULT 0,
  net_tx_bytes float8 DEFAULT NULL,
  net_rx_bytes float8 DEFAULT NULL,
  net_tx_pkts float8 DEFAULT NULL,
  net_rx_pkts float8 DEFAULT NULL,
  disk_total int4 NOT NULL DEFAULT 0,
  disk_read_reqs_sec float8 DEFAULT NULL,
  disk_write_reqs_sec float8 DEFAULT NULL,
  disk_read_bytes_sec float8 DEFAULT NULL,
  disk_write_bytes_sec float8 DEFAULT NULL,
  disk_physical int4 NOT NULL DEFAULT 0,
  disk_capacity int4 NOT NULL DEFAULT 0,
  clock int4 NOT NULL DEFAULT 0
);
CREATE INDEX virt_manager_status_idx_001 ON public.virt_manager_status USING btree (clock DESC);
SELECT create_hypertable('virt_manager_status', 'clock', chunk_time_interval => 86400, migrate_data => true);