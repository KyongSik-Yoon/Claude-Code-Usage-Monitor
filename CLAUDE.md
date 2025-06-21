# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Claude Code Usage Monitor is a Python-based terminal application that provides real-time monitoring of Claude AI token usage. It tracks token consumption across multiple 5-hour rolling sessions, displays visual progress bars, calculates burn rates, and predicts when tokens will run out.

## Core Architecture

### Main Components

- **`ccusage_monitor.py`**: Main application entry point containing the monitoring logic, UI rendering, and session management
- **`build.py`**: uv-based build script for packaging and installation 
- **`pyproject.toml`**: Modern Python packaging configuration using Hatchling build backend

### Key Dependencies

- **External**: `ccusage` (Node.js CLI tool) - provides raw Claude usage data via JSON API
- **Python**: `pytz` for timezone handling, standard library modules for subprocess, JSON parsing, datetime operations

### Data Flow

1. Subprocess calls to `ccusage blocks --json` retrieve usage data
2. JSON parsing and validation of session blocks
3. Token consumption analysis across overlapping 5-hour sessions
4. Real-time calculations for burn rate, progress, and predictions
5. Terminal UI rendering with colored progress bars and formatted output

## Development Commands

### Build and Installation

```bash
# Simple uv build
uv build

# Build and install locally
uv build && uv pip install dist/*.whl --force-reinstall --link-mode=copy

# Development installation
uv pip install -e . --link-mode=copy

# Install dependencies
uv pip install pytz --link-mode=copy
npm install -g ccusage

# Using justfile (if available)
just full-build    # Complete build process
just build         # Just build
just install       # Install dependencies
just test          # Test installation
```

### Testing

```bash
# Test installation
claude-usage-monitor --help

# Run with different configurations
./ccusage_monitor.py --plan pro
./ccusage_monitor.py --plan max5 --timezone US/Eastern
./ccusage_monitor.py --plan custom_max --reset-hour 9
```

### Virtual Environment Setup

```bash
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
# venv\Scripts\activate   # Windows
pip install pytz
```

## Session Management Logic

Claude Code operates on 5-hour rolling sessions that start with the user's first message. The monitor tracks multiple overlapping sessions and calculates:

- **Token Progress**: Current usage vs plan limits (Pro: ~7K, Max5: ~35K, Max20: ~140K)
- **Time Progress**: Countdown to next session expiration  
- **Burn Rate**: Tokens consumed per minute based on last hour of activity
- **Predictions**: Estimated time until token depletion

### Auto-Detection Features

- **Plan Switching**: Automatically upgrades from Pro to custom_max when limits exceeded
- **Limit Discovery**: Scans previous sessions to find actual token limits
- **Smart Notifications**: Alerts users when automatic plan changes occur

## Configuration Options

### Command Line Arguments

- `--plan`: pro, max5, max20, custom_max
- `--reset-hour`: Custom session reset time (0-23)
- `--timezone`: Any valid timezone (default: Europe/Warsaw)

### Environment Variables

- `CLAUDE_CONFIG_DIR`: Override default Claude configuration path (~/.config/claude)

## Code Style and Patterns

### UI Rendering

- Uses ANSI color codes for terminal formatting
- Progress bars with bracket-style visualization
- Clear separation between data processing and display logic
- Responsive terminal width handling

### Error Handling

- Graceful subprocess error handling for ccusage calls
- JSON parsing validation with informative error messages
- Session data validation and fallback mechanisms

### Time and Timezone Management

- All datetime operations use timezone-aware objects
- Configurable timezone support via pytz
- Consistent time formatting across the application

## Future Development

Planned features include ML-powered usage prediction, PyPI packaging, Docker containerization, and web dashboard interfaces. See DEVELOPMENT.md for detailed roadmap.