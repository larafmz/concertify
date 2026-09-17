--
-- PostgreSQL database dump
--

\restrict x20q94bkMPKJKBEdO8yDURWgnC0SkYzXDy6NWxfn4MvHgdKk19aQmzs6moq6vdv

-- Dumped from database version 16.15 (Debian 16.15-1.pgdg13+2)
-- Dumped by pg_dump version 16.15 (Debian 16.15-1.pgdg13+2)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_attachments OWNER TO postgres;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_attachments_id_seq OWNER TO postgres;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_blobs OWNER TO postgres;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_blobs_id_seq OWNER TO postgres;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


ALTER TABLE public.active_storage_variant_records OWNER TO postgres;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNER TO postgres;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO postgres;

--
-- Name: artists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artists (
    id bigint NOT NULL,
    name character varying,
    ticketmaster_id character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    genre_id bigint,
    requester_id bigint,
    status integer
);


ALTER TABLE public.artists OWNER TO postgres;

--
-- Name: artists_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artists_events (
    id bigint NOT NULL,
    artist_id bigint NOT NULL,
    event_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.artists_events OWNER TO postgres;

--
-- Name: artists_events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.artists_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.artists_events_id_seq OWNER TO postgres;

--
-- Name: artists_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.artists_events_id_seq OWNED BY public.artists_events.id;


--
-- Name: artists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.artists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.artists_id_seq OWNER TO postgres;

--
-- Name: artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.artists_id_seq OWNED BY public.artists.id;


--
-- Name: chat_entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_entries (
    id bigint NOT NULL,
    text character varying,
    chat_id bigint,
    user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    chat_type integer
);


ALTER TABLE public.chat_entries OWNER TO postgres;

--
-- Name: chat_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chat_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chat_entries_id_seq OWNER TO postgres;

--
-- Name: chat_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chat_entries_id_seq OWNED BY public.chat_entries.id;


--
-- Name: chat_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_users (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    chat_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    read_at timestamp(6) without time zone
);


ALTER TABLE public.chat_users OWNER TO postgres;

--
-- Name: chat_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chat_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chat_users_id_seq OWNER TO postgres;

--
-- Name: chat_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chat_users_id_seq OWNED BY public.chat_users.id;


--
-- Name: chats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chats (
    id bigint NOT NULL,
    event_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.chats OWNER TO postgres;

--
-- Name: chats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chats_id_seq OWNER TO postgres;

--
-- Name: chats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chats_id_seq OWNED BY public.chats.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    interactuable_id bigint NOT NULL,
    text character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    comment_father_id bigint
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comments_id_seq OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id bigint NOT NULL,
    name character varying,
    code character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.countries_id_seq OWNER TO postgres;

--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    ticketmaster_id character varying,
    tour_name character varying,
    date date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    ubication_id bigint,
    start_time timestamp(6) without time zone,
    request_id bigint
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.events_id_seq OWNER TO postgres;

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: favorite_artists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.favorite_artists (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    artist_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.favorite_artists OWNER TO postgres;

--
-- Name: favorite_artists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.favorite_artists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.favorite_artists_id_seq OWNER TO postgres;

--
-- Name: favorite_artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.favorite_artists_id_seq OWNED BY public.favorite_artists.id;


--
-- Name: future_assistances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.future_assistances (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    event_id bigint NOT NULL,
    "from" character varying,
    event_seat integer,
    event_seat_details character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    company integer
);


ALTER TABLE public.future_assistances OWNER TO postgres;

--
-- Name: future_assistances_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.future_assistances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.future_assistances_id_seq OWNER TO postgres;

--
-- Name: future_assistances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.future_assistances_id_seq OWNED BY public.future_assistances.id;


--
-- Name: genres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genres (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.genres OWNER TO postgres;

--
-- Name: genres_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.genres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.genres_id_seq OWNER TO postgres;

--
-- Name: genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.genres_id_seq OWNED BY public.genres.id;


--
-- Name: interactuables; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.interactuables (
    id bigint NOT NULL,
    type character varying,
    user_id bigint NOT NULL,
    review character varying,
    artist_id bigint,
    event_id bigint,
    rating integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.interactuables OWNER TO postgres;

--
-- Name: interactuables_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.interactuables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.interactuables_id_seq OWNER TO postgres;

--
-- Name: interactuables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.interactuables_id_seq OWNED BY public.interactuables.id;


--
-- Name: likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.likes (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    interactuable_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.likes OWNER TO postgres;

--
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.likes_id_seq OWNER TO postgres;

--
-- Name: likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.likes_id_seq OWNED BY public.likes.id;


--
-- Name: noticed_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.noticed_events (
    id bigint NOT NULL,
    type character varying,
    record_type character varying,
    record_id bigint,
    params jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    notifications_count integer
);


ALTER TABLE public.noticed_events OWNER TO postgres;

--
-- Name: noticed_events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.noticed_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.noticed_events_id_seq OWNER TO postgres;

--
-- Name: noticed_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.noticed_events_id_seq OWNED BY public.noticed_events.id;


--
-- Name: noticed_notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.noticed_notifications (
    id bigint NOT NULL,
    type character varying,
    event_id bigint NOT NULL,
    recipient_type character varying NOT NULL,
    recipient_id bigint NOT NULL,
    read_at timestamp without time zone,
    seen_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    chat_id bigint
);


ALTER TABLE public.noticed_notifications OWNER TO postgres;

--
-- Name: noticed_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.noticed_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.noticed_notifications_id_seq OWNER TO postgres;

--
-- Name: noticed_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.noticed_notifications_id_seq OWNED BY public.noticed_notifications.id;


--
-- Name: relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.relations (
    id bigint NOT NULL,
    follower_id bigint,
    relation_type integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    followed_type character varying NOT NULL,
    followed_id bigint NOT NULL
);


ALTER TABLE public.relations OWNER TO postgres;

--
-- Name: relations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.relations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.relations_id_seq OWNER TO postgres;

--
-- Name: relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.relations_id_seq OWNED BY public.relations.id;


--
-- Name: reposts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reposts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    interactuable_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.reposts OWNER TO postgres;

--
-- Name: reposts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reposts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reposts_id_seq OWNER TO postgres;

--
-- Name: reposts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reposts_id_seq OWNED BY public.reposts.id;


--
-- Name: requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.requests (
    id bigint NOT NULL,
    status integer,
    requester_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    message character varying,
    existing_event_id bigint
);


ALTER TABLE public.requests OWNER TO postgres;

--
-- Name: requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.requests_id_seq OWNER TO postgres;

--
-- Name: requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.requests_id_seq OWNED BY public.requests.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: tagged_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tagged_users (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    interactuable_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.tagged_users OWNER TO postgres;

--
-- Name: tagged_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tagged_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tagged_users_id_seq OWNER TO postgres;

--
-- Name: tagged_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tagged_users_id_seq OWNED BY public.tagged_users.id;


--
-- Name: ubications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ubications (
    id bigint NOT NULL,
    city character varying,
    state character varying,
    venue character varying,
    country_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    user_id bigint
);


ALTER TABLE public.ubications OWNER TO postgres;

--
-- Name: ubications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ubications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ubications_id_seq OWNER TO postgres;

--
-- Name: ubications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ubications_id_seq OWNED BY public.ubications.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    username character varying,
    description character varying,
    role_id bigint
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: artists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists ALTER COLUMN id SET DEFAULT nextval('public.artists_id_seq'::regclass);


--
-- Name: artists_events id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists_events ALTER COLUMN id SET DEFAULT nextval('public.artists_events_id_seq'::regclass);


--
-- Name: chat_entries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_entries ALTER COLUMN id SET DEFAULT nextval('public.chat_entries_id_seq'::regclass);


--
-- Name: chat_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_users ALTER COLUMN id SET DEFAULT nextval('public.chat_users_id_seq'::regclass);


--
-- Name: chats id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chats ALTER COLUMN id SET DEFAULT nextval('public.chats_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: favorite_artists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_artists ALTER COLUMN id SET DEFAULT nextval('public.favorite_artists_id_seq'::regclass);


--
-- Name: future_assistances id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.future_assistances ALTER COLUMN id SET DEFAULT nextval('public.future_assistances_id_seq'::regclass);


--
-- Name: genres id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres ALTER COLUMN id SET DEFAULT nextval('public.genres_id_seq'::regclass);


--
-- Name: interactuables id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interactuables ALTER COLUMN id SET DEFAULT nextval('public.interactuables_id_seq'::regclass);


--
-- Name: likes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.likes ALTER COLUMN id SET DEFAULT nextval('public.likes_id_seq'::regclass);


--
-- Name: noticed_events id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.noticed_events ALTER COLUMN id SET DEFAULT nextval('public.noticed_events_id_seq'::regclass);


--
-- Name: noticed_notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.noticed_notifications ALTER COLUMN id SET DEFAULT nextval('public.noticed_notifications_id_seq'::regclass);


--
-- Name: relations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relations ALTER COLUMN id SET DEFAULT nextval('public.relations_id_seq'::regclass);


--
-- Name: reposts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reposts ALTER COLUMN id SET DEFAULT nextval('public.reposts_id_seq'::regclass);


--
-- Name: requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests ALTER COLUMN id SET DEFAULT nextval('public.requests_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: tagged_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tagged_users ALTER COLUMN id SET DEFAULT nextval('public.tagged_users_id_seq'::regclass);


--
-- Name: ubications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ubications ALTER COLUMN id SET DEFAULT nextval('public.ubications_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
1	photo	Artist	1	1	2026-09-09 19:41:01.837028
\.


--
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.active_storage_blobs (id, key, filename, content_type, metadata, service_name, byte_size, checksum, created_at) FROM stdin;
1	lbijodxd7j9lfum15x9mcs50z1p1	https://s1.ticketm.net/dam/a/c5f/0ca2a6ed-c39b-44ed-954f-2b1391d73c5f_TABLET_LANDSCAPE_LARGE_16_9.jpg	image/jpeg	{"identified":true}	local	137304	lzQv0NQFQfuWWCNOv1Bpkg==	2026-09-09 19:41:01.834016
\.


--
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	production	2026-09-09 19:39:16.163913	2026-09-09 19:39:16.163919
schema_sha1	b8094f4b52027deaff24c12e01a88ed9860cd21d	2026-09-09 19:39:16.169101	2026-09-09 19:39:16.169104
\.


--
-- Data for Name: artists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artists (id, name, ticketmaster_id, created_at, updated_at, genre_id, requester_id, status) FROM stdin;
1	Billie Eilish	K8vZ9174Za7	2026-09-09 19:41:01.807366	2026-09-09 19:41:01.840379	18	\N	\N
\.


--
-- Data for Name: artists_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artists_events (id, artist_id, event_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: chat_entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_entries (id, text, chat_id, user_id, created_at, updated_at, chat_type) FROM stdin;
\.


--
-- Data for Name: chat_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_users (id, user_id, chat_id, created_at, updated_at, read_at) FROM stdin;
\.


--
-- Data for Name: chats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chats (id, event_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, user_id, interactuable_id, text, created_at, updated_at, comment_father_id) FROM stdin;
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (id, name, code, created_at, updated_at) FROM stdin;
1	Afghanistan	AF	2026-09-09 19:39:16.53051	2026-09-09 19:39:16.53051
2	Albania	AL	2026-09-09 19:39:16.545247	2026-09-09 19:39:16.545247
3	Algeria	DZ	2026-09-09 19:39:16.555346	2026-09-09 19:39:16.555346
4	American Samoa	AS	2026-09-09 19:39:16.563341	2026-09-09 19:39:16.563341
5	Andorra	AD	2026-09-09 19:39:16.573716	2026-09-09 19:39:16.573716
6	Angola	AO	2026-09-09 19:39:16.583875	2026-09-09 19:39:16.583875
7	Anguilla	AI	2026-09-09 19:39:16.596895	2026-09-09 19:39:16.596895
8	Antarctica	AQ	2026-09-09 19:39:16.606338	2026-09-09 19:39:16.606338
9	Antigua and Barbuda	AG	2026-09-09 19:39:16.616623	2026-09-09 19:39:16.616623
10	Argentina	AR	2026-09-09 19:39:16.627037	2026-09-09 19:39:16.627037
11	Armenia	AM	2026-09-09 19:39:16.638437	2026-09-09 19:39:16.638437
12	Aruba	AW	2026-09-09 19:39:16.649451	2026-09-09 19:39:16.649451
13	Australia	AU	2026-09-09 19:39:16.658853	2026-09-09 19:39:16.658853
14	Austria	AT	2026-09-09 19:39:16.668177	2026-09-09 19:39:16.668177
15	Azerbaijan	AZ	2026-09-09 19:39:16.676249	2026-09-09 19:39:16.676249
16	The Bahamas	BS	2026-09-09 19:39:16.685536	2026-09-09 19:39:16.685536
17	Bahrain	BH	2026-09-09 19:39:16.691731	2026-09-09 19:39:16.691731
18	Bangladesh	BD	2026-09-09 19:39:16.698243	2026-09-09 19:39:16.698243
19	Barbados	BB	2026-09-09 19:39:16.70439	2026-09-09 19:39:16.70439
20	Belarus	BY	2026-09-09 19:39:16.710764	2026-09-09 19:39:16.710764
21	Belgium	BE	2026-09-09 19:39:16.718196	2026-09-09 19:39:16.718196
22	Belize	BZ	2026-09-09 19:39:16.724923	2026-09-09 19:39:16.724923
23	Benin	BJ	2026-09-09 19:39:16.732974	2026-09-09 19:39:16.732974
24	Bermuda	BM	2026-09-09 19:39:16.739387	2026-09-09 19:39:16.739387
25	Bhutan	BT	2026-09-09 19:39:16.74514	2026-09-09 19:39:16.74514
26	Plurinational State of Bolivia	BO	2026-09-09 19:39:16.752236	2026-09-09 19:39:16.752236
27	Bonaire	 Sint Eustatius and Saba	2026-09-09 19:39:16.75812	2026-09-09 19:39:16.75812
28	Bosnia and Herzegovina	BA	2026-09-09 19:39:16.764534	2026-09-09 19:39:16.764534
29	Botswana	BW	2026-09-09 19:39:16.773404	2026-09-09 19:39:16.773404
30	Bouvet Island	BV	2026-09-09 19:39:16.780562	2026-09-09 19:39:16.780562
31	Brazil	BR	2026-09-09 19:39:16.788165	2026-09-09 19:39:16.788165
32	The British Indian Ocean Territory	IO	2026-09-09 19:39:16.795382	2026-09-09 19:39:16.795382
33	Brunei Darussalam	BN	2026-09-09 19:39:16.803793	2026-09-09 19:39:16.803793
34	Bulgaria	BG	2026-09-09 19:39:16.811178	2026-09-09 19:39:16.811178
35	Burkina Faso	BF	2026-09-09 19:39:16.818833	2026-09-09 19:39:16.818833
36	Burundi	BI	2026-09-09 19:39:16.826344	2026-09-09 19:39:16.826344
37	Cabo Verde	CV	2026-09-09 19:39:16.834288	2026-09-09 19:39:16.834288
38	Cambodia	KH	2026-09-09 19:39:16.841899	2026-09-09 19:39:16.841899
39	Cameroon	CM	2026-09-09 19:39:16.84852	2026-09-09 19:39:16.84852
40	Canada	CA	2026-09-09 19:39:16.855057	2026-09-09 19:39:16.855057
41	Cayman Islands	KY	2026-09-09 19:39:16.860794	2026-09-09 19:39:16.860794
42	Central African Republic	CF	2026-09-09 19:39:16.867971	2026-09-09 19:39:16.867971
43	Chad	TD	2026-09-09 19:39:16.876884	2026-09-09 19:39:16.876884
44	Chile	CL	2026-09-09 19:39:16.884484	2026-09-09 19:39:16.884484
45	China	CN	2026-09-09 19:39:16.890578	2026-09-09 19:39:16.890578
46	Christmas Island	CX	2026-09-09 19:39:16.896498	2026-09-09 19:39:16.896498
47	Keeling Cocos Islands	CC	2026-09-09 19:39:16.902442	2026-09-09 19:39:16.902442
48	Colombia	CO	2026-09-09 19:39:16.908542	2026-09-09 19:39:16.908542
49	Comoros	KM	2026-09-09 19:39:16.914807	2026-09-09 19:39:16.914807
50	Democratic Republic of the Congo	CD	2026-09-09 19:39:16.922399	2026-09-09 19:39:16.922399
51	Republic of the Congo	CG	2026-09-09 19:39:16.931114	2026-09-09 19:39:16.931114
52	Cook Islands	CK	2026-09-09 19:39:16.938111	2026-09-09 19:39:16.938111
53	Costa Rica	CR	2026-09-09 19:39:16.94532	2026-09-09 19:39:16.94532
54	Croatia	HR	2026-09-09 19:39:16.952166	2026-09-09 19:39:16.952166
55	Cuba	CU	2026-09-09 19:39:16.958574	2026-09-09 19:39:16.958574
56	Curaçao	CW	2026-09-09 19:39:16.965565	2026-09-09 19:39:16.965565
57	Cyprus	CY	2026-09-09 19:39:16.9719	2026-09-09 19:39:16.9719
58	Czechia	CZ	2026-09-09 19:39:16.978509	2026-09-09 19:39:16.978509
59	Côte d'Ivoire	CI	2026-09-09 19:39:16.985138	2026-09-09 19:39:16.985138
60	Denmark	DK	2026-09-09 19:39:16.99186	2026-09-09 19:39:16.99186
61	Djibouti	DJ	2026-09-09 19:39:16.999589	2026-09-09 19:39:16.999589
62	Dominica	DM	2026-09-09 19:39:17.006218	2026-09-09 19:39:17.006218
63	Dominican Republic	DO	2026-09-09 19:39:17.013722	2026-09-09 19:39:17.013722
64	Ecuador	EC	2026-09-09 19:39:17.020172	2026-09-09 19:39:17.020172
65	Egypt	EG	2026-09-09 19:39:17.026914	2026-09-09 19:39:17.026914
66	El Salvador	SV	2026-09-09 19:39:17.033139	2026-09-09 19:39:17.033139
67	Equatorial Guinea	GQ	2026-09-09 19:39:17.039107	2026-09-09 19:39:17.039107
68	Eritrea	ER	2026-09-09 19:39:17.045939	2026-09-09 19:39:17.045939
69	Estonia	EE	2026-09-09 19:39:17.052953	2026-09-09 19:39:17.052953
70	Eswatini	SZ	2026-09-09 19:39:17.061442	2026-09-09 19:39:17.061442
71	Ethiopia	ET	2026-09-09 19:39:17.068372	2026-09-09 19:39:17.068372
72	Falkland Islands	FK	2026-09-09 19:39:17.0754	2026-09-09 19:39:17.0754
73	Faroe Islands	FO	2026-09-09 19:39:17.082901	2026-09-09 19:39:17.082901
74	Fiji	FJ	2026-09-09 19:39:17.090197	2026-09-09 19:39:17.090197
75	Finland	FI	2026-09-09 19:39:17.097913	2026-09-09 19:39:17.097913
76	France	FR	2026-09-09 19:39:17.105111	2026-09-09 19:39:17.105111
77	French Guiana	GF	2026-09-09 19:39:17.112399	2026-09-09 19:39:17.112399
78	French Polynesia	PF	2026-09-09 19:39:17.119737	2026-09-09 19:39:17.119737
79	French Southern Territories	TF	2026-09-09 19:39:17.126978	2026-09-09 19:39:17.126978
80	Gabon	GA	2026-09-09 19:39:17.134032	2026-09-09 19:39:17.134032
81	Gambia	GM	2026-09-09 19:39:17.14161	2026-09-09 19:39:17.14161
82	Georgia	GE	2026-09-09 19:39:17.148969	2026-09-09 19:39:17.148969
83	Germany	DE	2026-09-09 19:39:17.156007	2026-09-09 19:39:17.156007
84	Ghana	GH	2026-09-09 19:39:17.163624	2026-09-09 19:39:17.163624
85	Gibraltar	GI	2026-09-09 19:39:17.170893	2026-09-09 19:39:17.170893
86	Greece	GR	2026-09-09 19:39:17.177902	2026-09-09 19:39:17.177902
87	Greenland	GL	2026-09-09 19:39:17.185044	2026-09-09 19:39:17.185044
88	Grenada	GD	2026-09-09 19:39:17.192104	2026-09-09 19:39:17.192104
89	Guadeloupe	GP	2026-09-09 19:39:17.199553	2026-09-09 19:39:17.199553
90	Guam	GU	2026-09-09 19:39:17.205939	2026-09-09 19:39:17.205939
91	Guatemala	GT	2026-09-09 19:39:17.212653	2026-09-09 19:39:17.212653
92	Guernsey	GG	2026-09-09 19:39:17.219432	2026-09-09 19:39:17.219432
93	Guinea	GN	2026-09-09 19:39:17.225665	2026-09-09 19:39:17.225665
94	Guinea-Bissau	GW	2026-09-09 19:39:17.233166	2026-09-09 19:39:17.233166
95	Guyana	GY	2026-09-09 19:39:17.239493	2026-09-09 19:39:17.239493
96	Haiti	HT	2026-09-09 19:39:17.245692	2026-09-09 19:39:17.245692
97	Heard Island and McDonald Islands	HM	2026-09-09 19:39:17.252285	2026-09-09 19:39:17.252285
98	Holy See	VA	2026-09-09 19:39:17.258527	2026-09-09 19:39:17.258527
99	Honduras	HN	2026-09-09 19:39:17.264909	2026-09-09 19:39:17.264909
100	Hong Kong	HK	2026-09-09 19:39:17.271744	2026-09-09 19:39:17.271744
101	Hungary	HU	2026-09-09 19:39:17.277693	2026-09-09 19:39:17.277693
102	Iceland	IS	2026-09-09 19:39:17.284425	2026-09-09 19:39:17.284425
103	India	IN	2026-09-09 19:39:17.290455	2026-09-09 19:39:17.290455
104	Indonesia	ID	2026-09-09 19:39:17.29787	2026-09-09 19:39:17.29787
105	Iran	IR	2026-09-09 19:39:17.305236	2026-09-09 19:39:17.305236
106	Iraq	IQ	2026-09-09 19:39:17.311834	2026-09-09 19:39:17.311834
107	Ireland	IE	2026-09-09 19:39:17.31945	2026-09-09 19:39:17.31945
108	Isle of Man	IM	2026-09-09 19:39:17.325442	2026-09-09 19:39:17.325442
109	Israel	IL	2026-09-09 19:39:17.331163	2026-09-09 19:39:17.331163
110	Italy	IT	2026-09-09 19:39:17.338233	2026-09-09 19:39:17.338233
111	Jamaica	JM	2026-09-09 19:39:17.34428	2026-09-09 19:39:17.34428
112	Japan	JP	2026-09-09 19:39:17.349961	2026-09-09 19:39:17.349961
113	Jersey	JE	2026-09-09 19:39:17.356617	2026-09-09 19:39:17.356617
114	Jordan	JO	2026-09-09 19:39:17.36244	2026-09-09 19:39:17.36244
115	Kazakhstan	KZ	2026-09-09 19:39:17.368794	2026-09-09 19:39:17.368794
116	Kenya	KE	2026-09-09 19:39:17.375114	2026-09-09 19:39:17.375114
117	Kiribati	KI	2026-09-09 19:39:17.38093	2026-09-09 19:39:17.38093
118	North Korea	KP	2026-09-09 19:39:17.388075	2026-09-09 19:39:17.388075
119	South Korea	KR	2026-09-09 19:39:17.393917	2026-09-09 19:39:17.393917
120	Kuwait	KW	2026-09-09 19:39:17.400683	2026-09-09 19:39:17.400683
121	Kyrgyzstan	KG	2026-09-09 19:39:17.409467	2026-09-09 19:39:17.409467
122	Laos	LA	2026-09-09 19:39:17.417424	2026-09-09 19:39:17.417424
123	Latvia	LV	2026-09-09 19:39:17.424577	2026-09-09 19:39:17.424577
124	Lebanon	LB	2026-09-09 19:39:17.430551	2026-09-09 19:39:17.430551
125	Lesotho	LS	2026-09-09 19:39:17.437081	2026-09-09 19:39:17.437081
126	Liberia	LR	2026-09-09 19:39:17.443373	2026-09-09 19:39:17.443373
127	Libya	LY	2026-09-09 19:39:17.449547	2026-09-09 19:39:17.449547
128	Liechtenstein	LI	2026-09-09 19:39:17.456882	2026-09-09 19:39:17.456882
129	Lithuania	LT	2026-09-09 19:39:17.463458	2026-09-09 19:39:17.463458
130	Luxembourg	LU	2026-09-09 19:39:17.469768	2026-09-09 19:39:17.469768
131	Macao	MO	2026-09-09 19:39:17.476628	2026-09-09 19:39:17.476628
132	Madagascar	MG	2026-09-09 19:39:17.482443	2026-09-09 19:39:17.482443
133	Malawi	MW	2026-09-09 19:39:17.488406	2026-09-09 19:39:17.488406
134	Malaysia	MY	2026-09-09 19:39:17.494783	2026-09-09 19:39:17.494783
135	Maldives	MV	2026-09-09 19:39:17.501479	2026-09-09 19:39:17.501479
136	Mali	ML	2026-09-09 19:39:17.507706	2026-09-09 19:39:17.507706
137	Malta	MT	2026-09-09 19:39:17.513793	2026-09-09 19:39:17.513793
138	Marshall Islands	MH	2026-09-09 19:39:17.520244	2026-09-09 19:39:17.520244
139	Martinique	MQ	2026-09-09 19:39:17.526488	2026-09-09 19:39:17.526488
140	Mauritania	MR	2026-09-09 19:39:17.532827	2026-09-09 19:39:17.532827
141	Mauritius	MU	2026-09-09 19:39:17.53926	2026-09-09 19:39:17.53926
142	Mayotte	YT	2026-09-09 19:39:17.545781	2026-09-09 19:39:17.545781
143	Mexico	MX	2026-09-09 19:39:17.551641	2026-09-09 19:39:17.551641
144	Micronesia	FM	2026-09-09 19:39:17.55733	2026-09-09 19:39:17.55733
145	Moldova	MD	2026-09-09 19:39:17.563481	2026-09-09 19:39:17.563481
146	Monaco	MC	2026-09-09 19:39:17.571127	2026-09-09 19:39:17.571127
147	Mongolia	MN	2026-09-09 19:39:17.577518	2026-09-09 19:39:17.577518
148	Montenegro	ME	2026-09-09 19:39:17.584071	2026-09-09 19:39:17.584071
149	Montserrat	MS	2026-09-09 19:39:17.589815	2026-09-09 19:39:17.589815
150	Morocco	MA	2026-09-09 19:39:17.596291	2026-09-09 19:39:17.596291
151	Mozambique	MZ	2026-09-09 19:39:17.602427	2026-09-09 19:39:17.602427
152	Myanmar	MM	2026-09-09 19:39:17.60869	2026-09-09 19:39:17.60869
153	Namibia	NA	2026-09-09 19:39:17.615122	2026-09-09 19:39:17.615122
154	Nauru	NR	2026-09-09 19:39:17.621272	2026-09-09 19:39:17.621272
155	Nepal	NP	2026-09-09 19:39:17.627309	2026-09-09 19:39:17.627309
156	Netherlands	NL	2026-09-09 19:39:17.633999	2026-09-09 19:39:17.633999
157	New Caledonia	NC	2026-09-09 19:39:17.640686	2026-09-09 19:39:17.640686
158	New Zealand	NZ	2026-09-09 19:39:17.647086	2026-09-09 19:39:17.647086
159	Nicaragua	NI	2026-09-09 19:39:17.653412	2026-09-09 19:39:17.653412
160	Niger	NE	2026-09-09 19:39:17.659664	2026-09-09 19:39:17.659664
161	Nigeria	NG	2026-09-09 19:39:17.6661	2026-09-09 19:39:17.6661
162	Niue	NU	2026-09-09 19:39:17.672752	2026-09-09 19:39:17.672752
163	Norfolk Island	NF	2026-09-09 19:39:17.679352	2026-09-09 19:39:17.679352
164	Northern Mariana Islands	MP	2026-09-09 19:39:17.686174	2026-09-09 19:39:17.686174
165	Norway	NO	2026-09-09 19:39:17.692477	2026-09-09 19:39:17.692477
166	Oman	OM	2026-09-09 19:39:17.699735	2026-09-09 19:39:17.699735
167	Pakistan	PK	2026-09-09 19:39:17.706315	2026-09-09 19:39:17.706315
168	Palau	PW	2026-09-09 19:39:17.71274	2026-09-09 19:39:17.71274
169	Palestine	PS	2026-09-09 19:39:17.71917	2026-09-09 19:39:17.71917
170	Panama	PA	2026-09-09 19:39:17.725501	2026-09-09 19:39:17.725501
171	Papua New Guinea	PG	2026-09-09 19:39:17.732194	2026-09-09 19:39:17.732194
172	Paraguay	PY	2026-09-09 19:39:17.741398	2026-09-09 19:39:17.741398
173	Peru	PE	2026-09-09 19:39:17.74808	2026-09-09 19:39:17.74808
174	Philippines	PH	2026-09-09 19:39:17.754484	2026-09-09 19:39:17.754484
175	Pitcairn	PN	2026-09-09 19:39:17.760462	2026-09-09 19:39:17.760462
176	Poland	PL	2026-09-09 19:39:17.766881	2026-09-09 19:39:17.766881
177	Portugal	PT	2026-09-09 19:39:17.773348	2026-09-09 19:39:17.773348
178	Puerto Rico	PR	2026-09-09 19:39:17.779605	2026-09-09 19:39:17.779605
179	Qatar	QA	2026-09-09 19:39:17.785972	2026-09-09 19:39:17.785972
180	North Macedonia	MK	2026-09-09 19:39:17.792213	2026-09-09 19:39:17.792213
181	Romania	RO	2026-09-09 19:39:17.798427	2026-09-09 19:39:17.798427
182	Russia	RU	2026-09-09 19:39:17.804898	2026-09-09 19:39:17.804898
183	Rwanda	RW	2026-09-09 19:39:17.813778	2026-09-09 19:39:17.813778
184	Réunion	RE	2026-09-09 19:39:17.820869	2026-09-09 19:39:17.820869
185	Saint Barthélemy	BL	2026-09-09 19:39:17.82725	2026-09-09 19:39:17.82725
186	Saint Helena	SH	2026-09-09 19:39:17.833191	2026-09-09 19:39:17.833191
187	Saint Kitts and Nevis	KN	2026-09-09 19:39:17.840985	2026-09-09 19:39:17.840985
188	Saint Lucia	LC	2026-09-09 19:39:17.847857	2026-09-09 19:39:17.847857
189	Saint Martin	MF	2026-09-09 19:39:17.854817	2026-09-09 19:39:17.854817
190	Saint Pierre and Miquelon	PM	2026-09-09 19:39:17.861224	2026-09-09 19:39:17.861224
191	Saint Vincent and the Grenadines	VC	2026-09-09 19:39:17.867291	2026-09-09 19:39:17.867291
192	Samoa	WS	2026-09-09 19:39:17.874114	2026-09-09 19:39:17.874114
193	San Marino	SM	2026-09-09 19:39:17.880256	2026-09-09 19:39:17.880256
194	Sao Tome and Principe	ST	2026-09-09 19:39:17.886131	2026-09-09 19:39:17.886131
195	Saudi Arabia	SA	2026-09-09 19:39:17.892549	2026-09-09 19:39:17.892549
196	Senegal	SN	2026-09-09 19:39:17.898805	2026-09-09 19:39:17.898805
197	Serbia	RS	2026-09-09 19:39:17.906413	2026-09-09 19:39:17.906413
198	Seychelles	SC	2026-09-09 19:39:17.912622	2026-09-09 19:39:17.912622
199	Sierra Leone	SL	2026-09-09 19:39:17.918426	2026-09-09 19:39:17.918426
200	Singapore	SG	2026-09-09 19:39:17.9256	2026-09-09 19:39:17.9256
201	Sint Maarten	SX	2026-09-09 19:39:17.931459	2026-09-09 19:39:17.931459
202	Slovakia	SK	2026-09-09 19:39:17.937428	2026-09-09 19:39:17.937428
203	Slovenia	SI	2026-09-09 19:39:17.944045	2026-09-09 19:39:17.944045
204	Solomon Islands	SB	2026-09-09 19:39:17.950211	2026-09-09 19:39:17.950211
205	Somalia	SO	2026-09-09 19:39:17.958768	2026-09-09 19:39:17.958768
206	South Africa	ZA	2026-09-09 19:39:17.967047	2026-09-09 19:39:17.967047
207	South Georgia and South Sandwich Islands	GS	2026-09-09 19:39:17.974044	2026-09-09 19:39:17.974044
208	South Sudan	SS	2026-09-09 19:39:17.980956	2026-09-09 19:39:17.980956
209	Spain	ES	2026-09-09 19:39:17.987634	2026-09-09 19:39:17.987634
210	Sri Lanka	LK	2026-09-09 19:39:17.994003	2026-09-09 19:39:17.994003
211	Sudan	SD	2026-09-09 19:39:17.999906	2026-09-09 19:39:17.999906
212	Suriname	SR	2026-09-09 19:39:18.005887	2026-09-09 19:39:18.005887
213	Svalbard and Jan Mayen	SJ	2026-09-09 19:39:18.012141	2026-09-09 19:39:18.012141
214	Sweden	SE	2026-09-09 19:39:18.018317	2026-09-09 19:39:18.018317
215	Switzerland	CH	2026-09-09 19:39:18.024264	2026-09-09 19:39:18.024264
216	Syria	SY	2026-09-09 19:39:18.030469	2026-09-09 19:39:18.030469
217	Taiwan	TW	2026-09-09 19:39:18.036513	2026-09-09 19:39:18.036513
218	Tajikistan	TJ	2026-09-09 19:39:18.042975	2026-09-09 19:39:18.042975
219	Tanzania	TZ	2026-09-09 19:39:18.049082	2026-09-09 19:39:18.049082
220	Thailand	TH	2026-09-09 19:39:18.055094	2026-09-09 19:39:18.055094
221	Timor-Leste	TL	2026-09-09 19:39:18.061786	2026-09-09 19:39:18.061786
222	Togo	TG	2026-09-09 19:39:18.068348	2026-09-09 19:39:18.068348
223	Tokelau	TK	2026-09-09 19:39:18.074522	2026-09-09 19:39:18.074522
224	Tonga	TO	2026-09-09 19:39:18.08072	2026-09-09 19:39:18.08072
225	Trinidad and Tobago	TT	2026-09-09 19:39:18.087141	2026-09-09 19:39:18.087141
226	Tunisia	TN	2026-09-09 19:39:18.093034	2026-09-09 19:39:18.093034
227	Turkey	TR	2026-09-09 19:39:18.100142	2026-09-09 19:39:18.100142
228	Turkmenistan	TM	2026-09-09 19:39:18.10631	2026-09-09 19:39:18.10631
229	Tuvalu	TV	2026-09-09 19:39:18.112885	2026-09-09 19:39:18.112885
230	Uganda	UG	2026-09-09 19:39:18.118802	2026-09-09 19:39:18.118802
231	Ukraine	UA	2026-09-09 19:39:18.124763	2026-09-09 19:39:18.124763
232	United Arab Emirates	AE	2026-09-09 19:39:18.131555	2026-09-09 19:39:18.131555
233	United Kingdom	GB	2026-09-09 19:39:18.137569	2026-09-09 19:39:18.137569
234	United States	US	2026-09-09 19:39:18.143502	2026-09-09 19:39:18.143502
235	Uruguay	UY	2026-09-09 19:39:18.149966	2026-09-09 19:39:18.149966
236	Uzbekistan	UZ	2026-09-09 19:39:18.15591	2026-09-09 19:39:18.15591
237	Vanuatu	VU	2026-09-09 19:39:18.162263	2026-09-09 19:39:18.162263
238	Venezuela	VE	2026-09-09 19:39:18.169212	2026-09-09 19:39:18.169212
239	Vietnam	VN	2026-09-09 19:39:18.175017	2026-09-09 19:39:18.175017
240	Virgin Islands (British)	VG	2026-09-09 19:39:18.181488	2026-09-09 19:39:18.181488
241	Virgin Islands (U.S.)	VI	2026-09-09 19:39:18.188423	2026-09-09 19:39:18.188423
242	Wallis and Futuna	WF	2026-09-09 19:39:18.194746	2026-09-09 19:39:18.194746
243	Western Sahara	EH	2026-09-09 19:39:18.201535	2026-09-09 19:39:18.201535
244	Yemen	YE	2026-09-09 19:39:18.207501	2026-09-09 19:39:18.207501
245	Zambia	ZM	2026-09-09 19:39:18.213355	2026-09-09 19:39:18.213355
246	Zimbabwe	ZW	2026-09-09 19:39:18.220421	2026-09-09 19:39:18.220421
247	Åland Islands	AX	2026-09-09 19:39:18.226191	2026-09-09 19:39:18.226191
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (id, ticketmaster_id, tour_name, date, created_at, updated_at, ubication_id, start_time, request_id) FROM stdin;
\.


--
-- Data for Name: favorite_artists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favorite_artists (id, user_id, artist_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: future_assistances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.future_assistances (id, user_id, event_id, "from", event_seat, event_seat_details, created_at, updated_at, company) FROM stdin;
\.


--
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genres (id, name, created_at, updated_at) FROM stdin;
1	Alternative	2026-09-09 19:39:19.103595	2026-09-09 19:39:19.103595
2	Ballads/Romantic	2026-09-09 19:39:19.108984	2026-09-09 19:39:19.108984
3	Blues	2026-09-09 19:39:19.114951	2026-09-09 19:39:19.114951
4	Chanson Francaise	2026-09-09 19:39:19.120404	2026-09-09 19:39:19.120404
5	Children's Music	2026-09-09 19:39:19.125553	2026-09-09 19:39:19.125553
6	Classical	2026-09-09 19:39:19.131193	2026-09-09 19:39:19.131193
7	Country	2026-09-09 19:39:19.136381	2026-09-09 19:39:19.136381
8	Dance/Electronic	2026-09-09 19:39:19.141784	2026-09-09 19:39:19.141784
9	Folk	2026-09-09 19:39:19.147353	2026-09-09 19:39:19.147353
10	Hip-Hop/Rap	2026-09-09 19:39:19.152442	2026-09-09 19:39:19.152442
11	Holiday	2026-09-09 19:39:19.157456	2026-09-09 19:39:19.157456
12	Jazz	2026-09-09 19:39:19.16233	2026-09-09 19:39:19.16233
13	Latin	2026-09-09 19:39:19.167973	2026-09-09 19:39:19.167973
14	Medieval/Renaissance	2026-09-09 19:39:19.173322	2026-09-09 19:39:19.173322
15	Metal	2026-09-09 19:39:19.179144	2026-09-09 19:39:19.179144
16	New Age	2026-09-09 19:39:19.184693	2026-09-09 19:39:19.184693
17	Other	2026-09-09 19:39:19.190053	2026-09-09 19:39:19.190053
18	Pop	2026-09-09 19:39:19.19502	2026-09-09 19:39:19.19502
19	R&B	2026-09-09 19:39:19.200536	2026-09-09 19:39:19.200536
20	Reggae	2026-09-09 19:39:19.205537	2026-09-09 19:39:19.205537
21	Religious	2026-09-09 19:39:19.210423	2026-09-09 19:39:19.210423
22	Rock	2026-09-09 19:39:19.217144	2026-09-09 19:39:19.217144
23	Undefined	2026-09-09 19:39:19.223027	2026-09-09 19:39:19.223027
24	World	2026-09-09 19:39:19.227775	2026-09-09 19:39:19.227775
\.


--
-- Data for Name: interactuables; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.interactuables (id, type, user_id, review, artist_id, event_id, rating, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.likes (id, user_id, interactuable_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: noticed_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.noticed_events (id, type, record_type, record_id, params, created_at, updated_at, notifications_count) FROM stdin;
\.


--
-- Data for Name: noticed_notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.noticed_notifications (id, type, event_id, recipient_type, recipient_id, read_at, seen_at, created_at, updated_at, chat_id) FROM stdin;
\.


--
-- Data for Name: relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.relations (id, follower_id, relation_type, created_at, updated_at, followed_type, followed_id) FROM stdin;
\.


--
-- Data for Name: reposts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reposts (id, user_id, interactuable_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.requests (id, status, requester_id, created_at, updated_at, message, existing_event_id) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, created_at, updated_at) FROM stdin;
1	admin	2026-09-09 19:39:19.244568	2026-09-09 19:39:19.244568
2	user	2026-09-09 19:39:19.257784	2026-09-09 19:39:19.257784
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version) FROM stdin;
20260828112828
20260824124938
20260822133141
20260820103640
20260805152613
20260805152612
20260708141118
20260627103240
20260627102627
20260627102259
20260626124821
20260619175613
20260529185905
20260525181615
20260525181506
20260525180811
20260522180116
20260514180521
20260514151857
20260511195938
\.


--
-- Data for Name: tagged_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tagged_users (id, user_id, interactuable_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: ubications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ubications (id, city, state, venue, country_id, created_at, updated_at, user_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, created_at, updated_at, username, description, role_id) FROM stdin;
\.


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 1, true);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 1, true);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 1, false);


--
-- Name: artists_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.artists_events_id_seq', 1, false);


--
-- Name: artists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.artists_id_seq', 1, true);


--
-- Name: chat_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chat_entries_id_seq', 1, false);


--
-- Name: chat_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chat_users_id_seq', 1, false);


--
-- Name: chats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chats_id_seq', 1, false);


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_id_seq', 1, false);


--
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.countries_id_seq', 247, true);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_id_seq', 1, false);


--
-- Name: favorite_artists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.favorite_artists_id_seq', 1, false);


--
-- Name: future_assistances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.future_assistances_id_seq', 1, false);


--
-- Name: genres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genres_id_seq', 24, true);


--
-- Name: interactuables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.interactuables_id_seq', 1, false);


--
-- Name: likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.likes_id_seq', 1, false);


--
-- Name: noticed_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.noticed_events_id_seq', 1, false);


--
-- Name: noticed_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.noticed_notifications_id_seq', 1, false);


--
-- Name: relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.relations_id_seq', 1, false);


--
-- Name: reposts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reposts_id_seq', 1, false);


--
-- Name: requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.requests_id_seq', 1, false);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 2, true);


--
-- Name: tagged_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tagged_users_id_seq', 1, false);


--
-- Name: ubications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ubications_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: artists_events artists_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists_events
    ADD CONSTRAINT artists_events_pkey PRIMARY KEY (id);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: chat_entries chat_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_entries
    ADD CONSTRAINT chat_entries_pkey PRIMARY KEY (id);


--
-- Name: chat_users chat_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_users
    ADD CONSTRAINT chat_users_pkey PRIMARY KEY (id);


--
-- Name: chats chats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: favorite_artists favorite_artists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_artists
    ADD CONSTRAINT favorite_artists_pkey PRIMARY KEY (id);


--
-- Name: future_assistances future_assistances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.future_assistances
    ADD CONSTRAINT future_assistances_pkey PRIMARY KEY (id);


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);


--
-- Name: interactuables interactuables_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interactuables
    ADD CONSTRAINT interactuables_pkey PRIMARY KEY (id);


--
-- Name: likes likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


--
-- Name: noticed_events noticed_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.noticed_events
    ADD CONSTRAINT noticed_events_pkey PRIMARY KEY (id);


--
-- Name: noticed_notifications noticed_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.noticed_notifications
    ADD CONSTRAINT noticed_notifications_pkey PRIMARY KEY (id);


--
-- Name: relations relations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT relations_pkey PRIMARY KEY (id);


--
-- Name: reposts reposts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reposts
    ADD CONSTRAINT reposts_pkey PRIMARY KEY (id);


--
-- Name: requests requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tagged_users tagged_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tagged_users
    ADD CONSTRAINT tagged_users_pkey PRIMARY KEY (id);


--
-- Name: ubications ubications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ubications
    ADD CONSTRAINT ubications_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_artists_events_on_artist_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_artists_events_on_artist_id ON public.artists_events USING btree (artist_id);


--
-- Name: index_artists_events_on_artist_id_and_event_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_artists_events_on_artist_id_and_event_id ON public.artists_events USING btree (artist_id, event_id);


--
-- Name: index_artists_events_on_event_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_artists_events_on_event_id ON public.artists_events USING btree (event_id);


--
-- Name: index_artists_on_genre_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_artists_on_genre_id ON public.artists USING btree (genre_id);


--
-- Name: index_artists_on_requester_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_artists_on_requester_id ON public.artists USING btree (requester_id);


--
-- Name: index_chat_entries_on_chat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_chat_entries_on_chat_id ON public.chat_entries USING btree (chat_id);


--
-- Name: index_chat_entries_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_chat_entries_on_user_id ON public.chat_entries USING btree (user_id);


--
-- Name: index_chat_users_on_chat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_chat_users_on_chat_id ON public.chat_users USING btree (chat_id);


--
-- Name: index_chat_users_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_chat_users_on_user_id ON public.chat_users USING btree (user_id);


--
-- Name: index_chat_users_on_user_id_and_chat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_chat_users_on_user_id_and_chat_id ON public.chat_users USING btree (user_id, chat_id);


--
-- Name: index_chats_on_event_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_chats_on_event_id ON public.chats USING btree (event_id);


--
-- Name: index_comments_on_comment_father_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_comments_on_comment_father_id ON public.comments USING btree (comment_father_id);


--
-- Name: index_comments_on_interactuable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_comments_on_interactuable_id ON public.comments USING btree (interactuable_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_comments_on_user_id ON public.comments USING btree (user_id);


--
-- Name: index_events_on_request_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_events_on_request_id ON public.events USING btree (request_id);


--
-- Name: index_events_on_ubication_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_events_on_ubication_id ON public.events USING btree (ubication_id);


--
-- Name: index_favorite_artists_on_artist_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_favorite_artists_on_artist_id ON public.favorite_artists USING btree (artist_id);


--
-- Name: index_favorite_artists_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_favorite_artists_on_user_id ON public.favorite_artists USING btree (user_id);


--
-- Name: index_future_assistances_on_event_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_future_assistances_on_event_id ON public.future_assistances USING btree (event_id);


--
-- Name: index_future_assistances_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_future_assistances_on_user_id ON public.future_assistances USING btree (user_id);


--
-- Name: index_interactuables_on_artist_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_interactuables_on_artist_id ON public.interactuables USING btree (artist_id);


--
-- Name: index_interactuables_on_event_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_interactuables_on_event_id ON public.interactuables USING btree (event_id);


--
-- Name: index_interactuables_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_interactuables_on_user_id ON public.interactuables USING btree (user_id);


--
-- Name: index_likes_on_interactuable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_likes_on_interactuable_id ON public.likes USING btree (interactuable_id);


--
-- Name: index_likes_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_likes_on_user_id ON public.likes USING btree (user_id);


--
-- Name: index_noticed_events_on_record; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_noticed_events_on_record ON public.noticed_events USING btree (record_type, record_id);


--
-- Name: index_noticed_notifications_on_chat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_noticed_notifications_on_chat_id ON public.noticed_notifications USING btree (chat_id);


--
-- Name: index_noticed_notifications_on_event_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_noticed_notifications_on_event_id ON public.noticed_notifications USING btree (event_id);


--
-- Name: index_noticed_notifications_on_recipient; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_noticed_notifications_on_recipient ON public.noticed_notifications USING btree (recipient_type, recipient_id);


--
-- Name: index_relations_on_followed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_relations_on_followed ON public.relations USING btree (followed_type, followed_id);


--
-- Name: index_relations_on_follower_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_relations_on_follower_id ON public.relations USING btree (follower_id);


--
-- Name: index_reposts_on_interactuable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_reposts_on_interactuable_id ON public.reposts USING btree (interactuable_id);


--
-- Name: index_reposts_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_reposts_on_user_id ON public.reposts USING btree (user_id);


--
-- Name: index_requests_on_requester_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_requests_on_requester_id ON public.requests USING btree (requester_id);


--
-- Name: index_roles_on_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_roles_on_name ON public.roles USING btree (name);


--
-- Name: index_tagged_users_on_interactuable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_tagged_users_on_interactuable_id ON public.tagged_users USING btree (interactuable_id);


--
-- Name: index_tagged_users_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_tagged_users_on_user_id ON public.tagged_users USING btree (user_id);


--
-- Name: index_ubications_on_country_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ubications_on_country_id ON public.ubications USING btree (country_id);


--
-- Name: index_ubications_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_ubications_on_user_id ON public.ubications USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_users_on_role_id ON public.users USING btree (role_id);


--
-- Name: comments fk_rails_00132b8b22; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_00132b8b22 FOREIGN KEY (interactuable_id) REFERENCES public.interactuables(id);


--
-- Name: comments fk_rails_03de2dc08c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_03de2dc08c FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: comments fk_rails_0d348a58c6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_0d348a58c6 FOREIGN KEY (comment_father_id) REFERENCES public.comments(id);


--
-- Name: artists_events fk_rails_19144ee017; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists_events
    ADD CONSTRAINT fk_rails_19144ee017 FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: likes fk_rails_1e09b5dabf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT fk_rails_1e09b5dabf FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: relations fk_rails_2929a0fe05; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT fk_rails_2929a0fe05 FOREIGN KEY (follower_id) REFERENCES public.users(id);


--
-- Name: future_assistances fk_rails_3172f9b868; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.future_assistances
    ADD CONSTRAINT fk_rails_3172f9b868 FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: chat_users fk_rails_3953ef352e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_users
    ADD CONSTRAINT fk_rails_3953ef352e FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: tagged_users fk_rails_412f5d3e34; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tagged_users
    ADD CONSTRAINT fk_rails_412f5d3e34 FOREIGN KEY (interactuable_id) REFERENCES public.interactuables(id);


--
-- Name: likes fk_rails_4db98a94f6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT fk_rails_4db98a94f6 FOREIGN KEY (interactuable_id) REFERENCES public.interactuables(id);


--
-- Name: artists_events fk_rails_52e5b28179; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists_events
    ADD CONSTRAINT fk_rails_52e5b28179 FOREIGN KEY (artist_id) REFERENCES public.artists(id);


--
-- Name: interactuables fk_rails_6d33c60688; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interactuables
    ADD CONSTRAINT fk_rails_6d33c60688 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: ubications fk_rails_71e4017b5e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ubications
    ADD CONSTRAINT fk_rails_71e4017b5e FOREIGN KEY (country_id) REFERENCES public.countries(id) ON DELETE CASCADE;


--
-- Name: reposts fk_rails_754c0e4c0e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reposts
    ADD CONSTRAINT fk_rails_754c0e4c0e FOREIGN KEY (interactuable_id) REFERENCES public.interactuables(id);


--
-- Name: favorite_artists fk_rails_758d1b4376; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_artists
    ADD CONSTRAINT fk_rails_758d1b4376 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: chat_users fk_rails_86a54ec29b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_users
    ADD CONSTRAINT fk_rails_86a54ec29b FOREIGN KEY (chat_id) REFERENCES public.chats(id);


--
-- Name: requests fk_rails_94f9f67433; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT fk_rails_94f9f67433 FOREIGN KEY (requester_id) REFERENCES public.users(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: tagged_users fk_rails_ac8f328b93; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tagged_users
    ADD CONSTRAINT fk_rails_ac8f328b93 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: artists fk_rails_b0c322a1e6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT fk_rails_b0c322a1e6 FOREIGN KEY (requester_id) REFERENCES public.users(id);


--
-- Name: reposts fk_rails_c395f67885; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reposts
    ADD CONSTRAINT fk_rails_c395f67885 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: favorite_artists fk_rails_d93f6d703a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_artists
    ADD CONSTRAINT fk_rails_d93f6d703a FOREIGN KEY (artist_id) REFERENCES public.artists(id);


--
-- Name: future_assistances fk_rails_ffb0695a37; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.future_assistances
    ADD CONSTRAINT fk_rails_ffb0695a37 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict x20q94bkMPKJKBEdO8yDURWgnC0SkYzXDy6NWxfn4MvHgdKk19aQmzs6moq6vdv

