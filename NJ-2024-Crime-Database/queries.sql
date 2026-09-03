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
