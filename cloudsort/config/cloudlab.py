from cloudsort.config.common import (
    Cloud,
    InstanceLifetime,
    InstanceType,
    JobConfig,
    SpillingMode,
    get_s3_buckets,
    get_steps,
)

m510 = InstanceType(
    name="m510",
    cpu=8,
    # FIXME might need to be 59.6
    memory_gib=64,
    disk_count=1,
    cloud=Cloud.CLOUDLAB,
)

configs = [
    JobConfig(
        name="600gb-86gb-m510",
        cluster=dict(
            instance_count=7,
            instance_type=m510,
        ),
        system=dict(
            max_fused_object_count=3,
            s3_spill=16,
        ),
        app=dict(
            **get_steps(),
            total_gb=600,
            input_part_gb=85.72,
            s3_buckets=get_s3_buckets(),
        ),
    ),
    JobConfig(
        name="1tb-143gb-m510",
        cluster=dict(
            instance_count=7,
            instance_type=m510,
            local=False,
        ),
        system=dict(),
        app=dict(
            **get_steps(),
            total_gb=1000,
            input_part_gb=142.86,
            map_parallelism_multiplier=1,
            reduce_parallelism_multiplier=1,
            s3_buckets=get_s3_buckets(),
            native_scheduling=True,
        ),
    ),
]
