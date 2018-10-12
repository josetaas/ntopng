--
-- (C) 2018 - ntop.org
--

local ts_utils = require "ts_utils_core"
local schema

-- ##############################################

schema = ts_utils.newSchema("iface:traffic", {step=1, rrd_fname="bytes"})
schema:addTag("ifid")
schema:addMetric("bytes")

-- ##############################################

schema = ts_utils.newSchema("iface:packets", {step=1, rrd_fname="packets"})
schema:addTag("ifid")
schema:addMetric("packets")

-- ##############################################

schema = ts_utils.newSchema("iface:zmq_recv_flows", {step=1, rrd_fname="num_zmq_rcvd_flows", metrics_type=ts_utils.metrics.gauge})
schema:addTag("ifid")
schema:addMetric("num_flows")

-- ##############################################

schema = ts_utils.newSchema("iface:drops", {step=1, rrd_fname="drops"})
schema:addTag("ifid")
schema:addMetric("packets")

-- ##############################################

schema = ts_utils.newSchema("iface:download", {step=1, rrd_fname="download"})
schema:addTag("ifid")
schema:addMetric("bytes")

-- ##############################################

schema = ts_utils.newSchema("iface:upload", {step=1, rrd_fname="upload"})
schema:addTag("ifid")
schema:addMetric("bytes")

-- ##############################################

schema = ts_utils.newSchema("subnet:traffic_per_second", {step=1, rrd_fname="traffic_per_second"})
schema:addTag("ifid")
schema:addTag("subnet")
schema:addMetric("bytes_ingress")
schema:addMetric("bytes_egress")
schema:addMetric("bytes_inner")
