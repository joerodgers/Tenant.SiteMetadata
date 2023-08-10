CREATE OR ALTER VIEW history.CmdletExecutionLatestCompleted
AS
    WITH cte AS
    (
        SELECT 
            CmdletId, MAX(Id) As Id
        FROM 
            history.CmdletExecution 
        WHERE
            StartDate IS NOT NULL AND 
            EndDate   IS NOT NULL
        GROUP BY 
            CmdletId
    )

    SELECT 
        Cmdlet,
        StartDate,
        EndDate,
        DATEDIFF(MINUTE, StartDate, COALESCE(EndDate, GETUTCDATE())) AS 'TotalMinutes',
        Host,
        ErrorCount
    FROM
        history.Cmdlet,
        history.CmdletExecution,
        cte
    WHERE
        Cmdlet.Id = CmdletExecution.CmdletId AND 
        CmdletExecution.Id = cte.Id
        
