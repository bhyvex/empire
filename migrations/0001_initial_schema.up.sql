CREATE EXTENSION IF NOT EXISTS hstore;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE apps (
  name varchar(30) NOT NULL primary key,
  repo text NOT NULL
);

CREATE TABLE configs (
  id text NOT NULL primary key,
  app_id text NOT NULL references apps(name),
  vars hstore
);

CREATE TABLE releases (
  id uuid NOT NULL primary key,
  app_id text NOT NULL references apps(name),
  version int NOT NULL
);

CREATE TABLE formations (
  id uuid NOT NULL primary key,
  release_id uuid NOT NULL references releases(id)
);

CREATE TABLE processes (
  id uuid NOT NULL primary key,
  formation_id uuid NOT NULL references formations(id),
  "type" text NOT NULL,
  quantity int NOT NULL,
  command text NOT NULL
);

CREATE TABLE slugs (
  id uuid NOT NULL DEFAULT uuid_generate_v4() primary key,
  image_repo text NOT NULL,
  image_id text NOT NULL,
  process_types hstore NOT NULL
);

CREATE UNIQUE INDEX index_apps_on_name ON apps USING btree (name);
CREATE UNIQUE INDEX index_processes_on_formation_id_and_type ON processes USING btree (formation_id, "type");