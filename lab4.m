function lab4  % Внутренние функции
  function signal = generate_signal(t, frequencies, amplitudes, phases, A0)    signal = zeros(size(t)) + A0;
    for k = 1:length(frequencies)      signal += amplitudes(k) * cos(2 * pi * frequencies(k) * t + phases(k));
    endfor  endfunction
  function restored_signal = sinc_interpolate(t, S, T)
    t_matrix = t' - T * (0:(length(S)-1));    sinc_matrix = sinc(t_matrix / T);
    restored_signal = sinc_matrix * S(:);  endfunction
  % Параметры сигнала
  n = 5;  A0 = 1;
  t_end = 1;  short_step = 0.001;
  % Генерация временной шкалы
  t = 0:short_step:(t_end-short_step);  frequencies = rand(1, n) * (50 - 1) + 1;
  amplitudes = rand(1, n) * (1.5 - 0.5) + 0.5;  phases = rand(1, n) * (2 * pi);
  % Генерация сигнала
  signal = generate_signal(t, frequencies, amplitudes, phases, A0);  f_max = max(frequencies);
  % Увеличенная частота дискретизации
  fd_high = 4 * f_max;  T_high = 1 / fd_high;
  sampled_times_A_high = 0:T_high:(t_end-T_high);  S_samples_A_high = generate_signal(sampled_times_A_high, frequencies, amplitudes, phases, A0);
  restored_signal_A_high = sinc_interpolate(t, S_samples_A_high, T_high);
  % Частота ниже Найквиста  fd_b = (3/2) * f_max;
  T_b = 1 / fd_b;  sampled_times_B = 0:T_b:(t_end-T_b);
  S_samples_B = generate_signal(sampled_times_B, frequencies, amplitudes, phases, A0);  restored_signal_B = sinc_interpolate(t, S_samples_B, T_b);
  % Вычисление стандартного отклонения
  std_A_high = std(signal - restored_signal_A_high);  std_B = std(signal - restored_signal_B);
  % Построение графиков
  figure;
  subplot(4, 1, 1);  plot(t, signal, 'DisplayName', 'Оригинальный сигнал');
  hold on;  plot(t, restored_signal_A_high, '--', 'DisplayName', 'Восстановленный сигнал (увеличенная частота)');
  scatter(sampled_times_A_high, S_samples_A_high, 'r', 'DisplayName', 'Отсчёты (увеличенные)');  xlabel('Время [с]');
  ylabel('Амплитуда');  title(sprintf('Случай A: f_{max} < f_N, std: %.3f', std_A_high));
  legend();  grid on;
% График 2: спектр исходного сигнала
subplot(4, 1, 2);frequencies_fft = (0:(length(t)-1)) / (length(t) * short_step);  % Ось частот
spectrum = abs(fft(signal)) / length(signal);  % Нормализованный спектр
% Отображаем первую половину спектраplot(frequencies_fft(1:floor(end/2)), spectrum(1:floor(end/2)), 'DisplayName', 'Спектр исходного сигнала');
hold on;
% Добавляем вертикальные линии для частот Найквистаline([fd_high / 2, fd_high / 2], ylim, 'Color', 'm', 'LineStyle', '--', 'LineWidth', 1.5, 'DisplayName', 'Частота Найквиста (увеличенная)');
line([fd_b / 2, fd_b / 2], ylim, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1.5, 'DisplayName', 'Частота Найквиста (случай B)');
xlabel('Частота [Гц]');ylabel('Амплитуда');
title('Спектр исходного сигнала');legend();
grid on;
  subplot(4, 1, 3);  plot(t, signal, 'DisplayName', 'Оригинальный сигнал');
  hold on;  plot(t, restored_signal_B, '--', 'DisplayName', 'Восстановленный сигнал (случай B)');
  scatter(sampled_times_B, S_samples_B, 'r', 'DisplayName', 'Отсчёты (случай B)');  xlabel('Время [с]');
  ylabel('Амплитуда');  title(sprintf('Случай B: f_{max} > f_N, std: %.3f', std_B));
  legend();  grid on;

% График 4: спектр восстановленного сигнала (случай B)subplot(4, 1, 4);
restored_spectrum_B = abs(fft(restored_signal_B)) / length(restored_signal_B);  % Нормализованный спектр
% Отображаем первую половину спектра
plot(frequencies_fft(1:floor(end/2)), restored_spectrum_B(1:floor(end/2)), 'DisplayName', 'Спектр восстановленного сигнала (случай B)');hold on;

% Добавляем вертикальные линии для частот Найквистаline([fd_high / 2, fd_high / 2], ylim, 'Color', 'm', 'LineStyle', '--', 'LineWidth', 1.5, 'DisplayName', 'Частота Найквиста (увеличенная)');
line([fd_b / 2, fd_b / 2], ylim, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1.5, 'DisplayName', 'Частота Найквиста (случай B)');
xlabel('Частота [Гц]');ylabel('Амплитуда');
title('Спектр восстановленного сигнала (случай B)');legend();
grid on;endfunction

