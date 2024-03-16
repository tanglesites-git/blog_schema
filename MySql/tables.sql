drop table if exists user_role cascade;

drop table if exists post_comment cascade;

drop table if exists post_category cascade;

drop table if exists post_tag cascade;

drop table if exists user_category cascade;

drop table if exists post_tag cascade;

drop table if exists user_tag cascade;

drop table if exists post cascade;

drop table if exists role cascade;

drop table if exists user cascade;

drop table if exists category cascade;

drop table if exists tag cascade;


create table if not exists role
(
    id        int          not null,
    role_name varchar(100) not null,
    CONSTRAINT pk_role_id primary key (id)
);

create table if not exists user
(
    id                    int          not null,
    first_name            int          not null,
    last_name             int          not null,
    normalized_first_name varchar(100) not null,
    normalized_last_name  varchar(100) not null,
    username              varchar(100) not null,
    normalized_username   varchar(100) not null,
    date_created          timestamp    not null,
    email                 varchar(100) not null,
    normalized_email      varchar(100) not null,
    password_hash         varchar(255) not null,
    city                  varchar(100) not null,
    state               varchar(100) not null,
    email_verified        smallint     not null default 0,
    concurrency_timestamp varchar(36)  not null,
    lockout_enabled       smallint     not null default 0,
    two_factored_enabled  smallint     not null default 0,
    constraint pk_user_id primary key (Id)
);

create index idx_user_normalized_email on user (normalized_email);
create index idx_user_normalized_first_name_normalized_last_name on user (normalized_first_name, normalized_last_name);
create index idx_user_date_created on user (date_created);
create index idx_user_city_state on user (city, state);
create index idx_user_email_verified on user (email_verified);

create table if not exists post
(
    id                  int                                 not null,
    title               varchar(100)                        not null,
    normalized_title    varchar(100)                        not null,
    subtitle            varchar(150)                        not null,
    normalized_subtitle varchar(150)                        not null,
    content           text                                not null,
    content_length      int                                 not null,
    content_preview     varchar(255)                        not null,
    word_count          int                                 not null,
    slug                varchar(100)                        not null,
    date_created        datetime                           not null,
    date_updated        datetime default current_timestamp on update current_timestamp not null,
    user_id             int                                 not null,
    constraint pk_post_id primary key (id),
    constraint fk_user_id foreign key (user_id) references user (id)
);

create index idx_post_normalized_title_normalized_subtitle on post (normalized_title, normalized_subtitle);
create index idx_post_slug on post (slug);
create index idx_post_date_created on post (date_created);
create index idx_post_date_updated on post (date_updated);
create index idx_post_word_count on post (word_count);
create index idx_post_content_preview on post (content_preview);

create table if not exists user_role
(
    user_id int not null,
    role_id int not null,
    constraint pk_user_id_role_id primary key (user_id, role_id),
    constraint fk_user_role_user_id foreign key (user_id) references user (id),
    constraint fk_user_role_role_id foreign key (role_id) references Role (id)
);

create table if not exists post_comment
(
    id           int          not null,
    post_id      int          not null,
    user_id      int          not null,
    comment      varchar(255) not null,
    date_created timestamp    not null,
    constraint pk_post_comment_id primary key (id),
    constraint fk_post_id foreign key (post_id) references post (id),
    constraint fk_post_comment_user_id foreign key (user_id) references user (id)
);

create index idx_post_comment_date_created on post_comment (date_created);
create index idx_post_comment_comment on post_comment (comment);

create table if not exists category
(
    id              int          not null,
    name            varchar(100) not null,
    normalized_name varchar(100) not null,
    date_created    timestamp    not null,
    constraint pk_post_comment_category_id primary key (id)
);

create index idx_category_normalized_name on category (normalized_name);
create index idx_category_date_created on category (date_created);

create table if not exists tag
(
    id              int          not null,
    name            varchar(100) not null,
    normalized_name varchar(100) not null,
    date_created    timestamp    not null,
    constraint pk_tag_tag_id primary key (id)
);

create index idx_tag_normalized_name on tag (normalized_name);
create index idx_tag_date_created on tag (date_created);

create table if not exists post_category
(
    post_id     int not null,
    category_id int not null,
    constraint pk_post_id_category_id primary key (post_id, category_id),
    constraint fk_post_category_post_id foreign key (post_id) references post (id),
    constraint fk_post_category_category_id foreign key (category_id) references category (id)
);

create table if not exists post_tag
(
    post_id int not null,
    tag_id  int not null,
    constraint pk_post_id_tag_id primary key (post_id, tag_id),
    constraint fk_post_tag_post_id foreign key (post_id) references post (id),
    constraint fk_post_tag_tag_id foreign key (tag_id) references tag (id)
);

create table if not exists user_category
(
    user_id     int not null,
    category_id int not null,
    constraint pk_user_id_category_id primary key (user_id, category_id),
    constraint fk_user_category_user_id foreign key (user_id) references user (id),
    constraint fk_user_category_category_id foreign key (category_id) references category (id)
);

create table if not exists user_tag
(
    user_id int not null,
    tag_id  int not null,
    constraint pk_user_id_tag_id primary key (user_id, tag_id),
    constraint fk_user_tag_user_id foreign key (user_id) references user (id),
    constraint fk_user_tag_tag_id foreign key (tag_id) references tag (id)
);