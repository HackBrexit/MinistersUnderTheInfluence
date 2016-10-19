--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

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
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: entities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: influence_office_people; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: means_of_influences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
    updated_at timestamp without time zone NOT NULL
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


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
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY entities
    ADD CONSTRAINT entities_pkey PRIMARY KEY (id);


--
-- Name: influence_office_people_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY influence_office_people
    ADD CONSTRAINT influence_office_people_pkey PRIMARY KEY (id);


--
-- Name: means_of_influences_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY means_of_influences
    ADD CONSTRAINT means_of_influences_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_influence_office_people_on_means_of_influence_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_influence_office_people_on_means_of_influence_id ON influence_office_people USING btree (means_of_influence_id);


--
-- Name: index_influence_office_people_on_office_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_influence_office_people_on_office_id ON influence_office_people USING btree (office_id);


--
-- Name: index_influence_office_people_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_influence_office_people_on_person_id ON influence_office_people USING btree (person_id);


--
-- Name: fk_rails_02a3ce01e6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY influence_office_people
    ADD CONSTRAINT fk_rails_02a3ce01e6 FOREIGN KEY (means_of_influence_id) REFERENCES means_of_influences(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20161002101731'), ('20161002141430'), ('20161002183132'), ('20161004124950');


