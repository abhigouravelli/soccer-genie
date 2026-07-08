CREATE TYPE confederation_type AS ENUM ('UEFA', 'CONMEBOL', 'CONCACAF', 'CAF', 'AFC', 'OFC');
CREATE TYPE event_type AS ENUM ('Goal', 'Own_Goal', 'Penalty_Goal', 'Yellow_Card', 'Red_Card', 'Second_Yellow', 'Assist', 'Substitution_In', 'Substitution_Out');
CREATE TYPE match_stage AS ENUM ('Group', 'R32', 'R16', 'QF', 'SF', 'Third_Place', 'Final');
CREATE TYPE match_status AS ENUM ('Scheduled', 'In_Progress', 'Completed', 'Cancelled');
CREATE TYPE position_type AS ENUM ('GK', 'DF', 'MF', 'FW');
