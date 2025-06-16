#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" << EOSQL

    CREATE DATABASE puc;

    GRANT ALL PRIVILEGES ON DATABASE puc TO postgres;

    \c puc

    CREATE TABLE public.usuarios
    (
        id serial NOT NULL,
        nome character varying(80) NOT NULL,
        email character varying(100) NOT NULL,
        data_cadastro timestamp without time zone NOT NULL DEFAULT clock_timestamp(),
        PRIMARY KEY (id)
    );

    ALTER TABLE public.usuarios
        OWNER to postgres;


    -- Table: public.produtos


    CREATE TABLE public.produtos
    (
        id serial NOT NULL,
        nome character varying(80) COLLATE pg_catalog."default" NOT NULL,
        descricao text COLLATE pg_catalog."default",
        preco numeric(6,2) NOT NULL,
        estoque integer NOT NULL,
        ativo boolean NOT NULL,
        CONSTRAINT produtos_pkey PRIMARY KEY (id)
    );


    ALTER TABLE IF EXISTS public.produtos
        OWNER to postgres;


    -- Table: public.produtos

    CREATE TABLE public.pedidos
    (
        id serial NOT NULL,
        usuario_id integer NOT NULL,
        data_pedido timestamp without time zone NOT NULL DEFAULT clock_timestamp(),
        status character varying NOT NULL,
        total numeric(6, 2) NOT NULL,
        PRIMARY KEY (id),
        CONSTRAINT fk_pedidos_usuarios FOREIGN KEY (usuario_id)
            REFERENCES public.usuarios (id) MATCH SIMPLE
            ON UPDATE NO ACTION
            ON DELETE NO ACTION
            NOT VALID
    );

    ALTER TABLE IF EXISTS public.pedidos
        OWNER to postgres;

    CREATE TABLE public.itens_pedidos
    (
        id serial NOT NULL,
        pedido_id integer NOT NULL,
        produto_id integer NOT NULL,
        quantidade integer NOT NULL,
        preco_unitario numeric(6, 2) NOT NULL,
        subtotal numeric(6, 2) NOT NULL,
        PRIMARY KEY (id),
        CONSTRAINT fk_itens_pedido_pedido FOREIGN KEY (pedido_id)
            REFERENCES public.pedidos (id) MATCH SIMPLE
            ON UPDATE NO ACTION
            ON DELETE NO ACTION
            NOT VALID,
        CONSTRAINT fk_itens_pedido_produto FOREIGN KEY (produto_id)
            REFERENCES public.produtos (id) MATCH SIMPLE
            ON UPDATE NO ACTION
            ON DELETE NO ACTION
            NOT VALID
    );

    ALTER TABLE IF EXISTS public.itens_pedidos
        OWNER to postgres;

EOSQL