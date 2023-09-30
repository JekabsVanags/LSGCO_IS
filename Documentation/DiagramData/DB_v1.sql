CREATE TABLE "Membership Fee Payments"(
    "id" BIGINT NOT NULL,
    "date" DATE NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "user_recorded" BIGINT NOT NULL,
    "user_payed" BIGINT NOT NULL
);
ALTER TABLE
    "Membership Fee Payments" ADD PRIMARY KEY("id");
CREATE TABLE "Invite"(
    "id" BIGINT NOT NULL,
    "unit" BIGINT NOT NULL,
    "rank" VARCHAR(255) CHECK
        ("rank" IN('')) NOT NULL,
        "event" BIGINT NOT NULL
);
ALTER TABLE
    "Invite" ADD PRIMARY KEY("id");
CREATE TABLE "Unit"(
    "id" BIGINT NOT NULL,
    "city" VARCHAR(255) NOT NULL,
    "number" BIGINT NOT NULL,
    "legal_adress" BIGINT NOT NULL,
    "activity_adress" VARCHAR(255) NOT NULL,
    "activity_location_name" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NULL,
    "phone" VARCHAR(255) NULL,
    "comments" TEXT NOT NULL,
    "bank_account" TEXT NOT NULL
);
ALTER TABLE
    "Unit" ADD PRIMARY KEY("id");
ALTER TABLE
    "Unit" ADD CONSTRAINT "unit_number_unique" UNIQUE("number");
CREATE TABLE "Personal Information"(
    "id" BIGINT NOT NULL,
    "user" BIGINT NOT NULL,
    "address" VARCHAR(255) NOT NULL,
    "emergency_contact_number" VARCHAR(255) NOT NULL,
    "emergency_contact_relationship" VARCHAR(255) CHECK
        (
            "emergency_contact_relationship" IN('')
        ) NOT NULL,
        "health_issues" TEXT NULL,
        "medication_during_event" TEXT NULL,
        "psychological_features" TEXT NULL,
        "diet" TEXT NOT NULL
);
ALTER TABLE
    "Personal Information" ADD PRIMARY KEY("id");
CREATE TABLE "User"(
    "id" BIGINT NOT NULL,
    "permission_level" VARCHAR(255) CHECK
        ("permission_level" IN('')) NOT NULL,
        "rank" VARCHAR(255)
    CHECK
        ("rank" IN('')) NOT NULL,
        "name" VARCHAR(255) NOT NULL,
        "surname" VARCHAR(255) NOT NULL,
        "unit" BIGINT NOT NULL,
        "phone" VARCHAR(255) NULL,
        "email" VARCHAR(255) NULL,
        "joined_date" DATE NOT NULL,
        "birth_date" DATE NOT NULL,
        "activity_statuss" VARCHAR(255)
    CHECK
        ("activity_statuss" IN('')) NOT NULL,
        "membership_fee_bilance" DOUBLE PRECISION NOT NULL,
        "sex" VARCHAR(255)
    CHECK
        ("sex" IN('')) NULL,
        "profile_picture" TEXT NULL
);
ALTER TABLE
    "User" ADD PRIMARY KEY("id");
CREATE TABLE "Weekly Activity"(
    "id" BIGINT NOT NULL,
    "unit" BIGINT NOT NULL,
    "day" VARCHAR(255) CHECK
        ("day" IN('')) NOT NULL,
        "time" TIME(0) WITHOUT TIME ZONE NOT NULL,
        "rank" VARCHAR(255)
    CHECK
        ("rank" IN('')) NOT NULL,
        "times_organized" BIGINT NOT NULL
);
ALTER TABLE
    "Weekly Activity" ADD PRIMARY KEY("id");
CREATE TABLE "Event"(
    "id" BIGINT NOT NULL,
    "organizer_unit" BIGINT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT NOT NULL,
    "date_from" DATE NOT NULL,
    "date_to" DATE NULL,
    "event_type" VARCHAR(255) CHECK
        ("event_type" IN('')) NOT NULL,
        "necessary_volunteers" BIGINT NOT NULL,
        "registered_volunteers" BIGINT NOT NULL,
        "max_participants" BIGINT NOT NULL,
        "registered_participants" BIGINT NOT NULL
);
ALTER TABLE
    "Event" ADD PRIMARY KEY("id");
CREATE TABLE "Event Registrations"(
    "id" BIGINT NOT NULL,
    "user" BIGINT NOT NULL,
    "event" BIGINT NOT NULL,
    "role" VARCHAR(255) CHECK
        ("role" IN('')) NOT NULL,
        "position" TEXT NOT NULL,
        "private_info_permission" BOOLEAN NOT NULL
);
ALTER TABLE
    "Event Registrations" ADD PRIMARY KEY("id");
CREATE TABLE "Position"(
    "id" BIGINT NOT NULL,
    "user" BIGINT NOT NULL,
    "structural_unit" BIGINT NOT NULL,
    "position_name" BIGINT NOT NULL
);
ALTER TABLE
    "Position" ADD PRIMARY KEY("id");
ALTER TABLE
    "Event Registrations" ADD CONSTRAINT "event registrations_user_foreign" FOREIGN KEY("user") REFERENCES "User"("id");
ALTER TABLE
    "User" ADD CONSTRAINT "user_unit_foreign" FOREIGN KEY("unit") REFERENCES "Unit"("id");
ALTER TABLE
    "Membership Fee Payments" ADD CONSTRAINT "membership fee payments_user_recorded_foreign" FOREIGN KEY("user_recorded") REFERENCES "User"("id");
ALTER TABLE
    "Invite" ADD CONSTRAINT "invite_event_foreign" FOREIGN KEY("event") REFERENCES "Event"("id");
ALTER TABLE
    "Membership Fee Payments" ADD CONSTRAINT "membership fee payments_user_payed_foreign" FOREIGN KEY("user_payed") REFERENCES "User"("id");
ALTER TABLE
    "Event Registrations" ADD CONSTRAINT "event registrations_event_foreign" FOREIGN KEY("event") REFERENCES "Event"("id");
ALTER TABLE
    "Event" ADD CONSTRAINT "event_organizer_unit_foreign" FOREIGN KEY("organizer_unit") REFERENCES "Unit"("id");
ALTER TABLE
    "User" ADD CONSTRAINT "user_activity_statuss_foreign" FOREIGN KEY("activity_statuss") REFERENCES "Position"("user");
ALTER TABLE
    "Weekly Activity" ADD CONSTRAINT "weekly activity_unit_foreign" FOREIGN KEY("unit") REFERENCES "Unit"("id");
ALTER TABLE
    "Personal Information" ADD CONSTRAINT "personal information_user_foreign" FOREIGN KEY("user") REFERENCES "User"("id");
ALTER TABLE
    "Invite" ADD CONSTRAINT "invite_unit_foreign" FOREIGN KEY("unit") REFERENCES "Unit"("id");