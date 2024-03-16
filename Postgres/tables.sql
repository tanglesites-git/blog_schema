drop table if exists "user_role" cascade;

drop table if exists "post_comment" cascade;

drop table if exists "post" cascade;

drop table if exists "role" cascade;

drop table if exists "user" cascade;

drop table if exists "post_category" cascade;

drop table if exists "category" cascade;

drop table if exists "post_tag" cascade;

drop table if exists "post_tag" cascade;

drop table if exists "tag" cascade;

drop table if exists "user_category" cascade;

drop table if exists "user_tag" cascade;

drop trigger if exists update_date_on_update_task on post;

drop function if exists update_date_on_update_task();

create table if not exists "role"
(
    id       int          not null,
    role_name varchar(100) not null,
    CONSTRAINT pk_role_id primary key (id)
);

create table if not exists "user"
(
    id                    int          not null,
    first_name            int          not null,
    last_name             int          not null,
    normalized_first_name varchar(100) not null,
    normalized_last_name  varchar(100) not null,
    date_created          timestamp    not null,
    email                 varchar(100) not null,
    normalized_email      varchar(100) not null,
    password_hash         varchar(255) not null,
    city                  varchar(100) not null,
    "state"               varchar(100) not null,
    email_verified        smallint     not null default 0,
    concurrency_timestamp uuid         not null,
    constraint pk_user_id primary key (Id)
);

create table if not exists "post"
(
    id                  int                                 not null,
    title               varchar(100)                        not null,
    normalized_title    varchar(100)                        not null,
    subtitle            varchar(150)                        not null,
    normalized_subtitle varchar(150)                        not null,
    "content"           text                                not null,
    slug                varchar(100)                        not null,
    date_created        timestamp                           not null,
    date_updated        timestamp default current_timestamp not null,
    user_id             int                                 not null,
    constraint pk_post_id primary key (id) ,
    constraint fk_user_id foreign key (user_id) references "user" (id)
);

create table if not exists "user_role" (
	user_id int not null ,
	role_id int not null ,
	constraint pk_user_id_role_id primary key (user_id, role_id) ,
	constraint fk_user_id foreign key (user_id) references "user" (id) ,
	constraint fk_role_id foreign key (role_id) references Role (id)
);

create table if not exists "post_comment" (
    id int not null ,
    post_id int not null ,
    user_id int not null ,
    comment varchar(255) not null ,
    date_created timestamp not null ,
    constraint pk_post_comment_id primary key (id) ,
    constraint fk_post_id foreign key (post_id) references "post" (id) ,
    constraint fk_user_id foreign key (user_id) references "user" (id)
);

create table if not exists "category" (
    id int not null ,
    name varchar(100) not null ,
    normalized_name varchar(100) not null ,
    date_created timestamp not null ,
    constraint pk_category_id primary key (id)
);

create table if not exists "tag" (
    id int not null ,
    name varchar(100) not null ,
    normalized_name varchar(100) not null ,
    date_created timestamp not null ,
    constraint pk_tag_id primary key (id)
);

create table if not exists "post_category" (
    post_id int not null ,
    category_id int not null ,
    constraint pk_post_id_category_id primary key (post_id, category_id) ,
    constraint fk_post_id foreign key (post_id) references "post" (id) ,
    constraint fk_category_id foreign key (category_id) references "category" (id)
);

create table if not exists "post_tag" (
    post_id int not null ,
    tag_id int not null ,
    constraint pk_post_id_tag_id primary key (post_id, tag_id) ,
    constraint fk_post_id foreign key (post_id) references "post" (id) ,
    constraint fk_tag_id foreign key (tag_id) references "tag" (id)
);

create table if not exists "user_category" (
    user_id int not null ,
    category_id int not null ,
    constraint pk_user_id_category_id primary key (user_id, category_id) ,
    constraint fk_user_id foreign key (user_id) references "user" (id) ,
    constraint fk_category_id foreign key (category_id) references "category" (id)
);

create table if not exists "user_tag" (
    user_id int not null ,
    tag_id int not null ,
    constraint pk_user_id_tag_id primary key (user_id, tag_id) ,
    constraint fk_user_id foreign key (user_id) references "user" (id) ,
    constraint fk_tag_id foreign key (tag_id) references "tag" (id)
);

create function update_date_on_update_task() returns trigger as
$$
begin
    new.date_updated = now();
    return new;
end;
$$ language 'plpgsql';

create trigger update_date_on_update_task
    before
        update
    on post
    for each row
execute procedure update_date_on_update_task();