-- ============================================================
-- OPTIONAL DEMO DATA — makes the Overview tab show LIVE scores
-- using the local database (no external API token required).
--
-- It assigns real teams to four of today's Round-of-32 fixtures
-- (match numbers 81, 84, 85, 86), marks two as In_Progress with
-- live scores, two as Completed, and adds goal events so scorers
-- appear on the match cards.
--
-- Run it against the running Postgres container:
--   docker exec -i soccer2026_db psql -U soccer_admin -d soccer2026 < app/demo_live.sql
--
-- Safe to re-run. To revert to the un-played (TBD) fixtures, see
-- the RESET block at the bottom (commented out).
-- ============================================================

BEGIN;

-- Assign teams + scores to today's four R32 matches.
UPDATE matches SET
  home_team_id = (SELECT t.id FROM teams t JOIN countries c ON c.id = t.country_id WHERE c.code = 'BRA'),
  away_team_id = (SELECT t.id FROM teams t JOIN countries c ON c.id = t.country_id WHERE c.code = 'KOR'),
  home_score = 3, away_score = 1, status = 'Completed'
WHERE match_number = 81;

UPDATE matches SET
  home_team_id = (SELECT t.id FROM teams t JOIN countries c ON c.id = t.country_id WHERE c.code = 'FRA'),
  away_team_id = (SELECT t.id FROM teams t JOIN countries c ON c.id = t.country_id WHERE c.code = 'SEN'),
  home_score = 2, away_score = 0, status = 'Completed'
WHERE match_number = 84;

UPDATE matches SET
  home_team_id = (SELECT t.id FROM teams t JOIN countries c ON c.id = t.country_id WHERE c.code = 'ARG'),
  away_team_id = (SELECT t.id FROM teams t JOIN countries c ON c.id = t.country_id WHERE c.code = 'AUS'),
  home_score = 1, away_score = 0, status = 'In_Progress'
WHERE match_number = 85;

UPDATE matches SET
  home_team_id = (SELECT t.id FROM teams t JOIN countries c ON c.id = t.country_id WHERE c.code = 'ESP'),
  away_team_id = (SELECT t.id FROM teams t JOIN countries c ON c.id = t.country_id WHERE c.code = 'UKR'),
  home_score = 2, away_score = 1, status = 'In_Progress'
WHERE match_number = 86;

-- Clear any previous demo goal events for these matches, then re-add them.
DELETE FROM match_events
WHERE match_id IN (SELECT id FROM matches WHERE match_number IN (81, 84, 85, 86));

-- Add goal events. `pick` selects the Nth-highest scorer on the team so a
-- multi-goal match spreads across different players.
INSERT INTO match_events (match_id, player_id, event, minute)
SELECT m.id, p.id, 'Goal'::event_type, g.minute
FROM (VALUES
  (81, 'BRA', 20, 1), (81, 'BRA', 55, 2), (81, 'BRA', 77, 3), (81, 'KOR', 60, 1),
  (84, 'FRA', 15, 1), (84, 'FRA', 66, 2),
  (85, 'ARG', 33, 1),
  (86, 'ESP', 24, 1), (86, 'ESP', 49, 2), (86, 'UKR', 71, 1)
) AS g(mnum, code, minute, pick)
JOIN matches   m ON m.match_number = g.mnum
JOIN countries c ON c.code = g.code
JOIN teams     t ON t.country_id = c.id
JOIN LATERAL (
  SELECT id FROM (
    SELECT id, ROW_NUMBER() OVER (ORDER BY goals DESC, id) AS rn
    FROM players WHERE team_id = t.id
  ) ranked
  WHERE ranked.rn = g.pick
  LIMIT 1
) p ON true;

COMMIT;

-- ── RESET (uncomment to undo the demo and restore TBD fixtures) ──────────────
-- BEGIN;
-- DELETE FROM match_events
-- WHERE match_id IN (SELECT id FROM matches WHERE match_number IN (81, 84, 85, 86));
-- UPDATE matches
-- SET home_team_id = NULL, away_team_id = NULL,
--     home_score = NULL, away_score = NULL, status = 'Scheduled'
-- WHERE match_number IN (81, 84, 85, 86);
-- COMMIT;
