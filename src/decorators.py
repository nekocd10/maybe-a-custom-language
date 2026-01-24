"""
Nexus Backend Decorator System
Handles @route, @model, @middleware, @auth, etc. for .nxsjs files
"""

from dataclasses import dataclass, field
from typing import List, Dict, Any, Optional, Callable
from enum import Enum

class DecoratorType(Enum):
    """All supported Nexus decorators for backends"""
    # Application & Environment
    CONFIG = "config"
    ENV = "env"
    PROFILE = "profile"
    FEATURE = "feature"
    FLAG = "flag"
    
    # Lifecycle & Execution
    STARTUP = "startup"
    SHUTDOWN = "shutdown"
    TASK = "task"
    CRON = "cron"
    WORKER = "worker"
    QUEUE = "queue"
    
    # Data & State
    MODEL = "model"
    REPOSITORY = "repository"
    TRANSACTION = "transaction"
    CACHE = "cache"
    INDEX = "index"
    MIGRATION = "migration"
    SEED = "seed"
    
    # Security
    AUTH = "auth"
    PERMISSION = "permission"
    ROLE = "role"
    POLICY = "policy"
    RATELIMIT = "ratelimit"
    CORS = "cors"
    CSRF = "csrf"
    
    # Validation & Contracts
    VALIDATE = "validate"
    SCHEMA = "schema"
    CONTRACT = "contract"
    SANITIZE = "sanitize"
    
    # Middleware & Handlers
    MIDDLEWARE = "middleware"
    HANDLER = "handler"
    
    # Observability
    LOG = "log"
    TRACE = "trace"
    METRIC = "metric"
    HEALTH = "health"
    AUDIT = "audit"
    
    # Performance & Scaling
    OPTIMIZE = "optimize"
    PARALLEL = "parallel"
    CLUSTER = "cluster"
    SHARD = "shard"
    LOADBALANCE = "loadbalance"
    
    # Error Handling & Resilience
    ERROR = "error"
    RETRY = "retry"
    FALLBACK = "fallback"
    TIMEOUT = "timeout"
    CIRCUITBREAKER = "circuitbreaker"
    
    # Modularity & Architecture
    MODULE = "module"
    SERVICE = "service"
    PLUGIN = "plugin"
    EXTENSION = "extension"
    BOUNDARY = "boundary"
    
    # Realtime & Networking
    SOCKET = "socket"
    STREAM = "stream"
    EVENT = "event"
    PUBSUB = "pubsub"
    CHANNEL = "channel"
    
    # Files & Media
    UPLOAD = "upload"
    FILE = "file"
    MEDIA = "media"
    CDN = "cdn"
    
    # Testing & Quality
    TEST = "test"
    MOCK = "mock"
    BENCHMARK = "benchmark"
    ASSERT = "assert"
    
    # Massive Scale Infrastructure (Fully Implementable)
    REPLICATE = "replicate"
    FAILOVER = "failover"
    CONSISTENCY = "consistency"
    GEODISTRIBUTE = "geodistribute"
    EDGE = "edge"
    APIGATEWAY = "apigateway"
    MESH = "mesh"
    PARTITION = "partition"
    MONITOR = "monitor"
    ALERT = "alert"
    CAPACITY = "capacity"
    QUOTA = "quota"
    METERING = "metering"
    THROTTLE = "throttle"
    DISTRIBUTE = "distribute"
    BACKUP = "backup"
    DATASTORE = "datastore"
    SECURITY = "security"
    SYNC = "sync"
    
    # Deployment & Infrastructure
    DEPLOY = "deploy"
    REGION = "region"
    RESOURCE = "resource"
    LIMIT = "limit"
    
    # HTTP Routes
    ROUTE = "route"
    GET = "get"
    POST = "post"
    PUT = "put"
    DELETE = "delete"
    PATCH = "patch"
    HEAD = "head"
    OPTIONS = "options"


@dataclass
class DecoratorConfig:
    """Configuration for a decorator"""
    type: DecoratorType
    args: List[Any] = field(default_factory=list)
    kwargs: Dict[str, Any] = field(default_factory=dict)
    
    def __repr__(self):
        args_str = ", ".join(str(a) for a in self.args)
        kwargs_str = ", ".join(f"{k}={v}" for k, v in self.kwargs.items())
        all_args = ", ".join(filter(None, [args_str, kwargs_str]))
        return f"@{self.type.value} {all_args}" if all_args else f"@{self.type.value}"


@dataclass
class BackendRoute:
    """HTTP Route definition"""
    method: str  # GET, POST, PUT, DELETE, PATCH
    path: str
    handlers: List[str] = field(default_factory=list)
    middleware: List[str] = field(default_factory=list)
    auth_required: bool = False
    rate_limited: bool = False
    cache_enabled: bool = False
    validation_schema: Optional[Dict] = None
    response_schema: Optional[Dict] = None
    timeout_ms: int = 30000
    retry_count: int = 0
    
    def __repr__(self):
        return f"@route {self.method} {self.path}"


@dataclass
class BackendModel:
    """Data model definition"""
    name: str
    fields: Dict[str, str]  # field_name -> type
    indexes: List[str] = field(default_factory=list)
    validations: Dict[str, List[str]] = field(default_factory=dict)
    hooks: Dict[str, List[str]] = field(default_factory=dict)  # before_save, after_save, etc.
    
    def __repr__(self):
        return f"@model {self.name}"


@dataclass
class BackendMiddleware:
    """Middleware definition"""
    name: str
    handler: str
    order: int = 0
    applies_to: List[str] = field(default_factory=list)  # routes it applies to
    
    def __repr__(self):
        return f"@middleware {self.name}"


@dataclass
class BackendService:
    """Service definition"""
    name: str
    methods: Dict[str, Callable] = field(default_factory=dict)
    dependencies: List[str] = field(default_factory=list)
    
    def __repr__(self):
        return f"@service {self.name}"


@dataclass
class BackendTask:
    """Background task definition"""
    name: str
    handler: str
    schedule: Optional[str] = None  # cron expression
    queue: str = "default"
    retry: int = 3
    timeout_ms: int = 60000
    
    def __repr__(self):
        return f"@task {self.name}"


@dataclass
class BackendConfig:
    """Application configuration"""
    port: int = 5000
    host: str = "0.0.0.0"
    database: Optional[str] = None
    redis: Optional[str] = None
    log_level: str = "info"
    environment: str = "development"
    debug: bool = False
    cors_enabled: bool = False
    cors_origins: List[str] = field(default_factory=list)
    rate_limit_enabled: bool = False
    rate_limit_requests: int = 100
    rate_limit_window_ms: int = 60000
    
    def __repr__(self):
        return "@config"


class BackendRegistry:
    """Registry for all backend decorators and their handlers"""
    
    def __init__(self):
        self.routes: Dict[str, BackendRoute] = {}
        self.models: Dict[str, BackendModel] = {}
        self.middleware: Dict[str, BackendMiddleware] = {}
        self.services: Dict[str, BackendService] = {}
        self.tasks: Dict[str, BackendTask] = {}
        self.config: BackendConfig = BackendConfig()
        self.decorators: List[DecoratorConfig] = []
    
    def register_route(self, route: BackendRoute):
        """Register an HTTP route"""
        key = f"{route.method}:{route.path}"
        self.routes[key] = route
        return route
    
    def register_model(self, model: BackendModel):
        """Register a data model"""
        self.models[model.name] = model
        return model
    
    def register_middleware(self, middleware: BackendMiddleware):
        """Register middleware"""
        self.middleware[middleware.name] = middleware
        return middleware
    
    def register_service(self, service: BackendService):
        """Register a service"""
        self.services[service.name] = service
        return service
    
    def register_task(self, task: BackendTask):
        """Register a background task"""
        self.tasks[task.name] = task
        return task
    
    def set_config(self, config: BackendConfig):
        """Set application configuration"""
        self.config = config
        return config
    
    def register_decorator(self, decorator: DecoratorConfig):
        """Register a generic decorator"""
        self.decorators.append(decorator)
        return decorator
    
    def get_all_routes(self) -> Dict[str, BackendRoute]:
        """Get all registered routes"""
        return self.routes.copy()
    
    def get_all_models(self) -> Dict[str, BackendModel]:
        """Get all registered models"""
        return self.models.copy()
    
    def get_route(self, method: str, path: str) -> Optional[BackendRoute]:
        """Get a specific route"""
        key = f"{method}:{path}"
        return self.routes.get(key)
    
    def get_model(self, name: str) -> Optional[BackendModel]:
        """Get a specific model"""
        return self.models.get(name)
    
    def summary(self) -> Dict:
        """Get a summary of all registered items"""
        return {
            "routes": len(self.routes),
            "models": len(self.models),
            "middleware": len(self.middleware),
            "services": len(self.services),
            "tasks": len(self.tasks),
            "decorators": len(self.decorators),
            "config": vars(self.config)
        }
    
    def __repr__(self):
        return f"BackendRegistry(routes={len(self.routes)}, models={len(self.models)}, middleware={len(self.middleware)})"


@dataclass
class DataReplication:
    """@replicate - Data replication across regions"""
    target_regions: List[str] = field(default_factory=list)
    replication_factor: int = 3
    consistency_level: str = "eventual"  # eventual, strong, causal
    conflict_resolution: str = "last-write-wins"  # last-write-wins, custom-merge
    
    def __post_init__(self):
        if self.replication_factor < 2:
            raise ValueError("Replication factor must be >= 2")


@dataclass
class FailoverConfig:
    """@failover - Automatic failover & recovery"""
    primary_region: str
    backup_regions: List[str] = field(default_factory=list)
    detection_timeout: int = 5  # seconds
    failover_strategy: str = "automatic"  # automatic, manual, semi-automatic
    recovery_mode: str = "heal"  # heal, restore, rebuild
    health_check_interval: int = 10  # seconds


@dataclass
class PartitionStrategy:
    """@partition - Data partitioning strategy"""
    partition_key: str
    partition_type: str = "hash"  # hash, range, directory
    num_partitions: int = 256
    rebalance_strategy: str = "consistent-hashing"  # consistent-hashing, ketama
    migration_threshold: int = 70  # rebalance when > 70% full


@dataclass
class ShardConfig:
    """@shard - Automatic database sharding"""
    shard_key: str
    num_shards: int = 256
    shard_strategy: str = "consistent-hash"  # consistent-hash, range, directory
    rebalance_enabled: bool = True
    migration_batch_size: int = 1000


@dataclass
class ConsistencyControl:
    """@consistency - Eventual consistency control"""
    model: str
    level: str = "eventual"  # eventual, causal, strong, linearizable
    ttl: int = 5000  # milliseconds for consistency window
    sync_interval: int = 1000  # milliseconds between syncs
    conflict_free: bool = False  # CRDT-based


@dataclass
class GeoDistribution:
    """@geodistribute - Global distribution"""
    regions: Dict[str, Dict[str, Any]] = field(default_factory=dict)  # region -> config
    primary_region: str = "us-east-1"
    edge_locations: List[str] = field(default_factory=list)
    data_residency: str = "local"  # local, global, compliant
    latency_target_ms: int = 50


@dataclass
class EdgeComputing:
    """@edge - Edge computing deployment"""
    function_name: str
    edge_locations: List[str] = field(default_factory=list)
    cache_behavior: str = "cache-first"  # cache-first, network-first, stale-while-revalidate
    timeout_ms: int = 5000
    enable_compression: bool = True


@dataclass
class APIGatewayConfig:
    """@apigateway - API gateway routing at scale"""
    name: str
    routes: Dict[str, str] = field(default_factory=dict)  # pattern -> backend
    rate_limit_strategy: str = "token-bucket"
    auth_type: str = "oauth2"
    enable_caching: bool = True
    cache_ttl_seconds: int = 300


@dataclass
class ServiceMesh:
    """@mesh - Service mesh (Istio-style)"""
    name: str
    services: List[str] = field(default_factory=list)
    mtls_enabled: bool = True
    traffic_policy: str = "round-robin"  # round-robin, least-conn, random
    circuit_breaker: bool = True
    max_retries: int = 3


@dataclass
class MonitoringConfig:
    """@monitor - Advanced observability"""
    metrics: List[str] = field(default_factory=list)
    sampling_rate: float = 0.1  # 0-1, percentage of requests
    log_level: str = "info"
    enable_profiling: bool = False
    retention_days: int = 30
    aggregation_interval: int = 60  # seconds


@dataclass
class AlertConfig:
    """@alert - Alert management"""
    name: str
    condition: str
    threshold: float
    duration: int  # seconds
    severity: str = "info"  # info, warning, critical
    notify_channels: List[str] = field(default_factory=list)


@dataclass
class AutoScalingConfig:
    """@capacity - Auto-scaling rules"""
    metric: str
    target_value: float
    min_capacity: int
    max_capacity: int
    scale_up_threshold: int = 80
    scale_down_threshold: int = 30
    cooldown_period: int = 300  # seconds


@dataclass
class QuotaConfig:
    """@quota - Usage-based rate limiting per user/team"""
    resource: str  # api_calls, storage, bandwidth
    limit: int
    time_window: int  # seconds
    enforcement: str = "soft"  # soft (warn), hard (block)
    per_entity: str = "user"  # user, team, org


@dataclass
class MeteringConfig:
    """@metering - Track API usage and resource consumption"""
    metrics: List[str] = field(default_factory=list)  # api_calls, data_processed, storage_used
    sampling_rate: float = 1.0  # 0-1, percentage
    granularity: str = "minute"  # minute, hour, day
    aggregation_enabled: bool = True
    export_format: str = "json"  # json, csv, parquet


@dataclass
class ThrottleConfig:
    """@throttle - Bandwidth and request throttling"""
    max_bandwidth_mbps: int = 1000
    max_requests_per_second: int = 10000
    burst_size: int = 50000  # max requests in burst
    algorithm: str = "token-bucket"


@dataclass
class DistributeConfig:
    """@distribute - Content distribution and caching"""
    distribution_points: List[str] = field(default_factory=list)  # regions/cities
    cache_strategy: str = "cache-first"  # cache-first, network-first
    ttl_seconds: int = 3600
    compression_enabled: bool = True
    cdn_enabled: bool = True


@dataclass
class BackupConfig:
    """@backup - Automated backups and snapshots"""
    schedule: str = "0 2 * * *"  # daily at 2 AM
    retention_days: int = 30
    backup_type: str = "incremental"  # incremental, full, differential
    locations: List[str] = field(default_factory=list)  # backup regions
    verify_integrity: bool = True


@dataclass
class DatastoreConfig:
    """@datastore - Data storage and optimization"""
    storage_type: str = "distributed"  # distributed, replicated, tiered
    compression: str = "snappy"  # snappy, gzip, lz4
    encoding: str = "utf-8"
    cold_storage_after_days: int = 90
    max_object_size_mb: int = 5120
    indexing_strategy: str = "adaptive"


@dataclass
class SecurityConfig:
    """@security - Built-in security rules"""
    encryption_at_rest: bool = True
    encryption_in_transit: bool = True
    key_rotation_days: int = 90
    audit_logging: bool = True
    rate_limit_suspicious: bool = True
    suspicious_threshold: int = 100  # requests/minute


@dataclass
class SyncConfig:
    """@sync - Cross-region synchronization"""
    sync_strategy: str = "eventual"  # eventual, causal, strong
    sync_interval_ms: int = 1000
    conflict_resolution: str = "last-write-wins"  # last-write-wins, first-write-wins, merge
    bidirectional: bool = True
    retries_on_failure: int = 3


# Global backend registry instance
backend_registry = BackendRegistry()


def get_backend_registry() -> BackendRegistry:
    """Get the global backend registry"""
    return backend_registry
