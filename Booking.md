# In this app we have two type of vendors and service 
1. Private Vendor
2. Decortaion Service Vendor 

When user see any decoration service that are coming and fetched from the 'service_listings' table then we store this data in the 'orders table ' 

Order table schema : 
create table public.orders (
  id uuid not null default gen_random_uuid (),
  vendor_id uuid null,
  customer_name text not null,
  customer_phone text null,
  customer_email text null,
  service_listing_id uuid null,
  service_title text not null,
  service_description text null,
  booking_date timestamp with time zone not null,
  booking_time time without time zone null,
  total_amount numeric(10, 2) not null default 0,
  status text not null default 'pending'::text,
  payment_status text not null default 'pending'::text,
  special_requirements text null,
  venue_address text null,
  venue_coordinates jsonb null,
  created_at timestamp with time zone null default now(),
  updated_at timestamp with time zone null default now(),
  advance_amount numeric null default 0,
  remaining_amount numeric null default 0,
  user_id uuid null,
  place_image_url text null,
  constraint orders_pkey primary key (id),
  constraint fk_orders_service_listing foreign KEY (service_listing_id) references service_listings (id) on delete set null,
  constraint orders_user_id_fkey foreign KEY (user_id) references auth.users (id),
  constraint orders_vendor_id_fkey foreign KEY (vendor_id) references vendors (id) on delete CASCADE,
  constraint orders_payment_status_check check (
    (
      payment_status = any (
        array['pending'::text, 'paid'::text, 'refunded'::text]
      )
    )
  ),
  constraint orders_status_check check (
    (
      status = any (
        array[
          'pending'::text,
          'confirmed'::text,
          'in_progress'::text,
          'completed'::text,
          'cancelled'::text
        ]
      )
    )
  )
) TABLESPACE pg_default;

create index IF not exists idx_orders_vendor_id on public.orders using btree (vendor_id) TABLESPACE pg_default;

create index IF not exists idx_orders_status on public.orders using btree (status) TABLESPACE pg_default;

create index IF not exists idx_orders_booking_date on public.orders using btree (booking_date) TABLESPACE pg_default;

create index IF not exists idx_orders_user_id on public.orders using btree (user_id) TABLESPACE pg_default;

create index IF not exists idx_orders_payment_status on public.orders using btree (payment_status) TABLESPACE pg_default;

create trigger orders_notification_trigger
after INSERT
or
update on orders for EACH row
execute FUNCTION notify_order_changes ();

create trigger trigger_notify_vendor_new_order
after INSERT on orders for EACH row
execute FUNCTION notify_vendor_new_order ();

create trigger update_orders_updated_at BEFORE
update on orders for EACH row
execute FUNCTION update_updated_at_column ();

when user see any theater that are coming and fetched from the 'private_theaters' table then we store this data in the 'private_theater_bookings' table  

Private Theater Booking table schema : 

create table public.private_theater_bookings (
  id uuid not null default gen_random_uuid (),
  theater_id uuid not null,
  time_slot_id uuid null,
  user_id uuid not null,
  booking_date date not null,
  start_time time without time zone not null,
  end_time time without time zone not null,
  total_amount numeric(10, 2) not null default 0.00,
  payment_status character varying(20) not null default 'pending'::character varying,
  payment_id character varying(255) null,
  booking_status character varying(20) not null default 'confirmed'::character varying,
  guest_count integer not null default 1,
  special_requests text null,
  contact_name character varying(255) not null,
  contact_phone character varying(20) not null,
  contact_email character varying(255) null,
  celebration_name character varying(255) null,
  number_of_people integer not null default 2,
  created_at timestamp with time zone null default now(),
  updated_at timestamp with time zone null default now(),
  vendor_id uuid not null,
  screen_id uuid null,
  occasion_name character varying(255) null,
  occasion_id uuid null,
  constraint private_theater_bookings_pkey primary key (id),
  constraint fk_private_theater_bookings_time_slot foreign KEY (time_slot_id) references theater_time_slots (id) on delete set null,
  constraint fk_theater_bookings_vendor foreign KEY (vendor_id) references user_profiles (id) on delete CASCADE,
  constraint fk_private_theater_bookings_theater foreign KEY (theater_id) references private_theaters (id) on delete CASCADE,
  constraint private_theater_bookings_screen_id_fkey foreign KEY (screen_id) references theater_screens (id),
  constraint private_theater_bookings_booking_status_check check (
    (
      (booking_status)::text = any (
        (
          array[
            'confirmed'::character varying,
            'cancelled'::character varying,
            'completed'::character varying,
            'no_show'::character varying
          ]
        )::text[]
      )
    )
  ),
  constraint valid_total_amount check ((total_amount >= (0)::numeric)),
  constraint valid_guest_count check ((guest_count > 0)),
  constraint valid_number_of_people check ((number_of_people > 0)),
  constraint private_theater_bookings_payment_status_check check (
    (
      (payment_status)::text = any (
        (
          array[
            'pending'::character varying,
            'paid'::character varying,
            'failed'::character varying,
            'refunded'::character varying
          ]
        )::text[]
      )
    )
  )
) TABLESPACE pg_default;

create index IF not exists idx_private_theater_bookings_theater_id on public.private_theater_bookings using btree (theater_id) TABLESPACE pg_default;

create index IF not exists idx_private_theater_bookings_user_id on public.private_theater_bookings using btree (user_id) TABLESPACE pg_default;

create index IF not exists idx_private_theater_bookings_booking_date on public.private_theater_bookings using btree (booking_date) TABLESPACE pg_default;

create index IF not exists idx_private_theater_bookings_status on public.private_theater_bookings using btree (booking_status) TABLESPACE pg_default;

create index IF not exists idx_private_theater_bookings_payment_status on public.private_theater_bookings using btree (payment_status) TABLESPACE pg_default;

create index IF not exists idx_private_theater_bookings_created_at on public.private_theater_bookings using btree (created_at) TABLESPACE pg_default;

create index IF not exists idx_theater_bookings_vendor_id on public.private_theater_bookings using btree (vendor_id) TABLESPACE pg_default;

create trigger private_theater_bookings_notification_trigger
after INSERT
or
update on private_theater_bookings for EACH row
execute FUNCTION notify_theater_booking_changes ();

create trigger trigger_notify_vendor_booking
after INSERT on private_theater_bookings for EACH row
execute FUNCTION notify_vendor_on_booking ();

create trigger trigger_notify_vendor_on_booking
after INSERT on private_theater_bookings for EACH row
execute FUNCTION notify_vendor_on_new_booking ();

create trigger trigger_update_private_theater_bookings_updated_at BEFORE
update on private_theater_bookings for EACH row
execute FUNCTION update_private_theater_bookings_updated_at ();