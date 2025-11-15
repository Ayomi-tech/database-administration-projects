-- View Project

 USE `mavenbearbbuilders`;
 
-- Table structure for website_sessions
CREATE TABLE website_sessions (
    website_session_id BIGINT,
    created_at DATETIME,
    user_id BIGINT,
    is_repeat_session INT,
    utm_scorce VARCHAR(50),
    utm_campaign VARCHAR(50),
    utm_content VARCHAR(50),
    device_type VARCHAR(50),
    http_referer VARCHAR(120),
    PRIMARY KEY (website_session_id)
);

/* This view provides the marketing team with safe, read-only access to aggregated data. It reduces the risk of unwanted modifications in the database and removes 
the need for the team to write complex aggregation queries. */

CREATE VIEW marketing_monthly_sessions AS
    SELECT 
        YEAR(created_at) AS year,
        MONTH(created_at) AS month,
        utm_scorce,
        utm_campaign,
        COUNT(website_session_id) AS number_of_sessions
    FROM
        website_sessions
    WHERE
        utm_scorce IS NOT NULL
            OR utm_campaign IS NOT NULL
    GROUP BY 1 , 2 , 3 , 4;






