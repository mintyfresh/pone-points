SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: achievements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.achievements (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL,
    pones_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT now() NOT NULL
);


--
-- Name: achievements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.achievements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: achievements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.achievements_id_seq OWNED BY public.achievements.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_keys (
    id bigint NOT NULL,
    pone_id bigint NOT NULL,
    token character varying NOT NULL,
    name character varying NOT NULL,
    description character varying,
    requests_count integer DEFAULT 0 NOT NULL,
    last_request_at timestamp without time zone,
    revoked_at timestamp without time zone,
    created_at timestamp(6) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT now() NOT NULL
);


--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.api_keys_id_seq OWNED BY public.api_keys.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.groups (
    id bigint NOT NULL,
    owner_id bigint NOT NULL,
    name public.citext NOT NULL,
    slug character varying NOT NULL,
    description character varying,
    members_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT now() NOT NULL
);


--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.memberships (
    id bigint NOT NULL,
    group_id bigint NOT NULL,
    member_id bigint NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT now() NOT NULL
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.memberships_id_seq OWNED BY public.memberships.id;


--
-- Name: points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.points (
    id bigint NOT NULL,
    pone_id bigint NOT NULL,
    granted_by_id bigint NOT NULL,
    message character varying,
    count integer NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT now() NOT NULL
);


--
-- Name: points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.points_id_seq OWNED BY public.points.id;


--
-- Name: pone_credentials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pone_credentials (
    id bigint NOT NULL,
    type character varying NOT NULL,
    pone_id bigint NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT now() NOT NULL,
    external_id character varying
);


--
-- Name: pone_credentials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pone_credentials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pone_credentials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pone_credentials_id_seq OWNED BY public.pone_credentials.id;


--
-- Name: pones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pones (
    id bigint NOT NULL,
    name public.citext NOT NULL,
    slug character varying NOT NULL,
    points_count integer DEFAULT 0 NOT NULL,
    daily_giftable_points_count integer DEFAULT 0 NOT NULL,
    verified_at timestamp without time zone,
    created_at timestamp(6) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT now() NOT NULL,
    bonus_points integer DEFAULT 0 NOT NULL,
    CONSTRAINT chk_rails_3769fed490 CHECK ((bonus_points >= 0))
);


--
-- Name: pones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pones_id_seq OWNED BY public.pones.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: unlocked_achievements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.unlocked_achievements (
    id bigint NOT NULL,
    pone_id bigint NOT NULL,
    achievement_id bigint NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT now() NOT NULL
);


--
-- Name: unlocked_achievements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.unlocked_achievements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: unlocked_achievements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.unlocked_achievements_id_seq OWNED BY public.unlocked_achievements.id;


--
-- Name: webhooks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.webhooks (
    id bigint NOT NULL,
    owner_id bigint NOT NULL,
    name character varying NOT NULL,
    signing_key character varying NOT NULL,
    events character varying[] NOT NULL,
    url character varying NOT NULL,
    created_at timestamp(6) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT now() NOT NULL,
    type character varying NOT NULL,
    event_source_type character varying NOT NULL,
    event_source_id bigint NOT NULL
);


--
-- Name: webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.webhooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.webhooks_id_seq OWNED BY public.webhooks.id;


--
-- Name: achievements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements ALTER COLUMN id SET DEFAULT nextval('public.achievements_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: api_keys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys ALTER COLUMN id SET DEFAULT nextval('public.api_keys_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships ALTER COLUMN id SET DEFAULT nextval('public.memberships_id_seq'::regclass);


--
-- Name: points id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.points ALTER COLUMN id SET DEFAULT nextval('public.points_id_seq'::regclass);


--
-- Name: pone_credentials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pone_credentials ALTER COLUMN id SET DEFAULT nextval('public.pone_credentials_id_seq'::regclass);


--
-- Name: pones id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pones ALTER COLUMN id SET DEFAULT nextval('public.pones_id_seq'::regclass);


--
-- Name: unlocked_achievements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unlocked_achievements ALTER COLUMN id SET DEFAULT nextval('public.unlocked_achievements_id_seq'::regclass);


--
-- Name: webhooks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhooks ALTER COLUMN id SET DEFAULT nextval('public.webhooks_id_seq'::regclass);


--
-- Name: achievements achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: memberships memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: points points_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.points
    ADD CONSTRAINT points_pkey PRIMARY KEY (id);


--
-- Name: pone_credentials pone_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pone_credentials
    ADD CONSTRAINT pone_credentials_pkey PRIMARY KEY (id);


--
-- Name: pones pones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pones
    ADD CONSTRAINT pones_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: unlocked_achievements unlocked_achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unlocked_achievements
    ADD CONSTRAINT unlocked_achievements_pkey PRIMARY KEY (id);


--
-- Name: webhooks webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhooks
    ADD CONSTRAINT webhooks_pkey PRIMARY KEY (id);


--
-- Name: index_achievements_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_achievements_on_name ON public.achievements USING btree (name);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_api_keys_on_pone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_api_keys_on_pone_id ON public.api_keys USING btree (pone_id);


--
-- Name: index_api_keys_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_api_keys_on_token ON public.api_keys USING btree (token);


--
-- Name: index_api_keys_on_token_hexdigest; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_api_keys_on_token_hexdigest ON public.api_keys USING hash (encode(public.digest((token)::text, 'sha256'::text), 'hex'::text));


--
-- Name: index_groups_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_groups_on_name ON public.groups USING btree (name);


--
-- Name: index_groups_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_groups_on_owner_id ON public.groups USING btree (owner_id);


--
-- Name: index_groups_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_groups_on_slug ON public.groups USING btree (slug);


--
-- Name: index_memberships_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_memberships_on_group_id ON public.memberships USING btree (group_id);


--
-- Name: index_memberships_on_group_id_and_member_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_memberships_on_group_id_and_member_id ON public.memberships USING btree (group_id, member_id);


--
-- Name: index_memberships_on_member_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_memberships_on_member_id ON public.memberships USING btree (member_id);


--
-- Name: index_points_on_granted_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_points_on_granted_by_id ON public.points USING btree (granted_by_id);


--
-- Name: index_points_on_pone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_points_on_pone_id ON public.points USING btree (pone_id);


--
-- Name: index_pone_credentials_on_pone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pone_credentials_on_pone_id ON public.pone_credentials USING btree (pone_id);


--
-- Name: index_pone_credentials_on_type_and_external_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pone_credentials_on_type_and_external_id ON public.pone_credentials USING btree (type, external_id);


--
-- Name: index_pone_credentials_on_type_and_pone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pone_credentials_on_type_and_pone_id ON public.pone_credentials USING btree (type, pone_id);


--
-- Name: index_pones_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pones_on_name ON public.pones USING btree (name);


--
-- Name: index_pones_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pones_on_slug ON public.pones USING btree (slug);


--
-- Name: index_unlocked_achievements_on_achievement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_unlocked_achievements_on_achievement_id ON public.unlocked_achievements USING btree (achievement_id);


--
-- Name: index_unlocked_achievements_on_pone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_unlocked_achievements_on_pone_id ON public.unlocked_achievements USING btree (pone_id);


--
-- Name: index_unlocked_achievements_on_pone_id_and_achievement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unlocked_achievements_on_pone_id_and_achievement_id ON public.unlocked_achievements USING btree (pone_id, achievement_id);


--
-- Name: index_webhooks_on_event_source; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_webhooks_on_event_source ON public.webhooks USING btree (event_source_type, event_source_id);


--
-- Name: index_webhooks_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_webhooks_on_owner_id ON public.webhooks USING btree (owner_id);


--
-- Name: pone_credentials fk_rails_11e792e613; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pone_credentials
    ADD CONSTRAINT fk_rails_11e792e613 FOREIGN KEY (pone_id) REFERENCES public.pones(id);


--
-- Name: groups fk_rails_5447bdb9c5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT fk_rails_5447bdb9c5 FOREIGN KEY (owner_id) REFERENCES public.pones(id);


--
-- Name: api_keys fk_rails_65658346aa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT fk_rails_65658346aa FOREIGN KEY (pone_id) REFERENCES public.pones(id);


--
-- Name: points fk_rails_6d75f2081e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.points
    ADD CONSTRAINT fk_rails_6d75f2081e FOREIGN KEY (pone_id) REFERENCES public.pones(id);


--
-- Name: webhooks fk_rails_722c3a6266; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhooks
    ADD CONSTRAINT fk_rails_722c3a6266 FOREIGN KEY (owner_id) REFERENCES public.pones(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: points fk_rails_a46c897fdb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.points
    ADD CONSTRAINT fk_rails_a46c897fdb FOREIGN KEY (granted_by_id) REFERENCES public.pones(id);


--
-- Name: memberships fk_rails_aaf389f138; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT fk_rails_aaf389f138 FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: unlocked_achievements fk_rails_b38a46bfcf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unlocked_achievements
    ADD CONSTRAINT fk_rails_b38a46bfcf FOREIGN KEY (pone_id) REFERENCES public.pones(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: unlocked_achievements fk_rails_cf533a56c3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unlocked_achievements
    ADD CONSTRAINT fk_rails_cf533a56c3 FOREIGN KEY (achievement_id) REFERENCES public.achievements(id);


--
-- Name: memberships fk_rails_d50c4f4a6c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT fk_rails_d50c4f4a6c FOREIGN KEY (member_id) REFERENCES public.pones(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20210204221112'),
('20210204222146'),
('20210204231345'),
('20210205035320'),
('20210205035907'),
('20210205230501'),
('20210206011739'),
('20210206041844'),
('20210206223810'),
('20210208205331'),
('20210209004912'),
('20210209005853'),
('20210209025300'),
('20210209045522'),
('20210210225417');


