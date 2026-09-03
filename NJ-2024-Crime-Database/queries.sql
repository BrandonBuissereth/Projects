-- Query 1
SELECT
    a.county,
    COUNT(DISTINCT i.incident_id) AS total_incidents,
    COUNT(DISTINCT CASE
        WHEN inc.offense_code IN ('09A', '09B', '09C', '11A', '11B', '11C', '11D', '120', '13A')
        THEN i.incident_id
    END) AS violent_incidents,
    ROUND(
        1.0 * COUNT(DISTINCT CASE
            WHEN inc.offense_code IN ('09A', '09B', '09C', '11A', '11B', '11C', '11D', '120', '13A')
            THEN i.incident_id
        END) / COUNT(DISTINCT i.incident_id),
        3
    ) AS violent_ratio
FROM INCIDENT i
JOIN AGENCY a
    ON i.agency_id = a.agency_id
LEFT JOIN INCLUDES inc
    ON i.incident_id = inc.incident_id
GROUP BY a.county
ORDER BY violent_ratio DESC
LIMIT 50;

-- Query 2
SELECT
    a.agency_type_name,
    COUNT(i.incident_id) AS total_incidents,
    SUM(CASE
        WHEN i.cleared_flag IS NOT NULL
        AND i.cleared_flag != ''
        AND i.cleared_flag != '6'
        THEN 1
        ELSE 0
    END) AS cleared_incidents,
    ROUND(
        100.0 * SUM(CASE
            WHEN i.cleared_flag IS NOT NULL
            AND i.cleared_flag != ''
            AND i.cleared_flag != '6'
            THEN 1
            ELSE 0
        END) / COUNT(i.incident_id),
        2
    ) AS clearance_rate
FROM AGENCY a
JOIN INCIDENT i
    ON a.agency_id = i.agency_id
GROUP BY a.agency_type_name
ORDER BY clearance_rate DESC
LIMIT 50;
