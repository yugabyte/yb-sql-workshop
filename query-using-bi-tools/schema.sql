CREATE TABLE products(
  id         bigint PRIMARY KEY,
  created_at text,
  category   text,
  ean        text,
  price      float,
  rating     float,
  title      text,
  vendor     text
);

CREATE TABLE users(
  id         bigint PRIMARY KEY,
  created_at text,
  name       text,
  email      text,
  address    text,
  city       text,
  state      text,
  zip        text,
  birth_date text,
  latitude   float,
  longitude  float,
  password   text,
  source     text
);

CREATE TABLE orders(
  id         bigint PRIMARY KEY,
  created_at text,
  user_id    bigint,
  product_id bigint,
  discount   float,
  quantity   int,
  subtotal   float,
  tax        float,
  total      float
);

CREATE TABLE reviews(
  id         bigint PRIMARY KEY,
  created_at text,
  reviewer   text,
  product_id bigint,
  rating     int,
  body       text
);

