--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.4
-- Dumped by pg_dump version 9.5.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE entities (
    id integer NOT NULL,
    name character varying,
    wikipedia_entry character varying,
    type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: entities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE entities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: entities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE entities_id_seq OWNED BY entities.id;


--
-- Name: influence_office_people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE influence_office_people (
    id integer NOT NULL,
    means_of_influence_id integer,
    office_id integer,
    person_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying
);


--
-- Name: influence_office_people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE influence_office_people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: influence_office_people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE influence_office_people_id_seq OWNED BY influence_office_people.id;


--
-- Name: means_of_influences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE means_of_influences (
    id integer NOT NULL,
    type character varying,
    day integer,
    month integer,
    year integer,
    purpose character varying,
    type_of_hospitality character varying,
    gift character varying,
    value integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    source_file_id integer,
    source_file_line_number integer
);


--
-- Name: means_of_influences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE means_of_influences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: means_of_influences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE means_of_influences_id_seq OWNED BY means_of_influences.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: source_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE source_files (
    id integer NOT NULL,
    location character varying,
    uri character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: source_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE source_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: source_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE source_files_id_seq OWNED BY source_files.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY entities ALTER COLUMN id SET DEFAULT nextval('entities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY influence_office_people ALTER COLUMN id SET DEFAULT nextval('influence_office_people_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY means_of_influences ALTER COLUMN id SET DEFAULT nextval('means_of_influences_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY source_files ALTER COLUMN id SET DEFAULT nextval('source_files_id_seq'::regclass);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY entities
    ADD CONSTRAINT entities_pkey PRIMARY KEY (id);


--
-- Name: influence_office_people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY influence_office_people
    ADD CONSTRAINT influence_office_people_pkey PRIMARY KEY (id);


--
-- Name: means_of_influences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY means_of_influences
    ADD CONSTRAINT means_of_influences_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: source_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY source_files
    ADD CONSTRAINT source_files_pkey PRIMARY KEY (id);


--
-- Name: index_influence_office_people_on_means_of_influence_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_influence_office_people_on_means_of_influence_id ON influence_office_people USING btree (means_of_influence_id);


--
-- Name: index_influence_office_people_on_office_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_influence_office_people_on_office_id ON influence_office_people USING btree (office_id);


--
-- Name: index_influence_office_people_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_influence_office_people_on_person_id ON influence_office_people USING btree (person_id);


--
-- Name: index_means_of_influences_on_source_file_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_means_of_influences_on_source_file_id ON means_of_influences USING btree (source_file_id);


--
-- Name: fk_rails_02a3ce01e6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY influence_office_people
    ADD CONSTRAINT fk_rails_02a3ce01e6 FOREIGN KEY (means_of_influence_id) REFERENCES means_of_influences(id);


--
-- Name: fk_rails_d23fbbd690; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY means_of_influences
    ADD CONSTRAINT fk_rails_d23fbbd690 FOREIGN KEY (source_file_id) REFERENCES source_files(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20161002101731'), ('20161002141430'), ('20161002183132'), ('20161004124950'), ('20161212073547'), ('20161213075431'), ('20161213091029');


