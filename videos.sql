create table videos
  (
    id serial8 primary key,
    title varchar(50),
    description varchar(250),
    video text,
    genre varchar(50)
  );

