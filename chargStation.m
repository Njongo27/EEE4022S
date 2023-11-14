classdef chargStation
    properties
        % Charging station properties
        Pricing
        Availability
    end

    methods
        function theCS = chargStation()
            % Initialize the charging station
            theCS.Pricing = 1; % Default pricing
            theCS.Availability = 1; % Initially available of CS
        end

        function obs = observe(theCS)
            % Return observation of CS state
            obs = [theCS.Pricing; theCS.Availability];
        end

        function amendPricing(theCS, action)
            % Adjust pricing based on agent's action
            theCS.Pricing = action;
        end

        function reset(theCS)
            % Reset the charging station to its initial condition
            theCS.Pricing = 1.0; % Reset pricing
            theCS.Availability = 1; % Reset availability
        end
    end
end
