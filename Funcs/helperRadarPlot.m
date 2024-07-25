classdef helperRadarPlot
    
    properties (Access = protected)
        fig
        ax1
        ax2
        fov
    end
    
    methods
        
        function obj = helperRadarPlot(fov)
            
            obj.fig = figure('Visible','on');
            obj.ax1 = subplot(2,1,1);
            obj.ax2 = subplot(2,1,2);
            xlabel(obj.ax1, 'Azimuth (deg)');
            xlabel(obj.ax2, 'Azimuth (deg)');
            ylabel(obj.ax1, 'Elevation (deg)');
            ylabel(obj.ax2, 'Elevation (deg)');
            
            xlim(obj.ax1, [-fov(1)/2 fov(1)/2]);
            xlim(obj.ax2, [-fov(1)/2 fov(1)/2]);
            ylim(obj.ax1, [-fov(2)/2 fov(2)/2]);
            ylim(obj.ax2, [-fov(2)/2 fov(2)/2]);
            title(obj.ax1, 'Radar 1 Field of View');
            title(obj.ax2, 'Radar 2 Field of View');
            box(obj.ax1, 'on');
            box(obj.ax2, 'on');
            axis(obj.ax1, 'equal');
            axis(obj.ax2, 'equal');
            hold(obj.ax1, 'on');
            hold(obj.ax2, 'on');
            obj.fov = fov;
        end
        
        function updateRadarPlots(obj,targets1, targets2 ,dets1, dets2)
            % Plot satellites from the constellation as the enter the field of view of
            % each radar
            Ry90 = [0 0 -1 ; 0 1 0; 1 0 0]; % frame rotation of 90 deg around y axis
            for i=1:numel(targets1)
                % convert position from body cartesian to sensor spherical
                pos_p = targets1(i).Position;
                % first convert body cartesian to sensor cartesian
                pos_s = Ry90 * pos_p(:);
                % convert sensor cartesian to sensor spherical
                [az, el, ~] = cart2sph(pos_s(1), pos_s(2), pos_s(3));
                azd = rad2deg(az);
                eld = rad2deg(el);
                % if azimuth and elevation is within field of view, plot satellite
                if abs(azd) < obj.fov(1)/2 && abs(eld) < obj.fov(2)/2
                    plot(obj.ax1, azd, eld, 'b','LineWidth',3, 'Marker','.');
                end
            end
            
            for i=1:numel(targets2)
                % convert position from body cartesian to sensor spherical
                pos_p = targets2(i).Position;
                % first convert body cartesian to sensor cartesian
                pos_s = Ry90 * pos_p(:);
                % convert sensor cartesian to sensor spherical
                [az, el, ~] = cart2sph(pos_s(1), pos_s(2), pos_s(3));
                azd = rad2deg(az);
                eld = rad2deg(el);
                % if azimuth and elevation is within field of view, plot satellite
                if abs(rad2deg(az)) < obj.fov(1)/2 && abs(rad2deg(el)) < obj.fov(2)/2
                    plot(obj.ax2, azd, eld, 'b','LineWidth',3, 'Marker','.');
                end
            end
            
            % Plot az - el measurement
            for i=1:numel(dets1)
                meas = dets1{i}.Measurement;
                plot(obj.ax1, meas(1), meas(2), 'ro');
            end
            for i=1:numel(dets2)
                meas = dets2{i}.Measurement;
                plot(obj.ax2, meas(1), meas(2), 'ro');
            end
            drawnow limitrate
        end
    end
end