import json
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Basic Lambda function handler

    Args:
        event: AWS Lambda event data
        context: AWS Lambda context object

    Returns:
        dict: Response with status code and message
    """
    try:
        # Log the incoming event
        logger.info(f"Event received: {json.dumps(event)}")

        # Extract name from event if available, otherwise use default
        name = event.get('name', 'World')

        # Create response
        response = {
            'statusCode': 200,
            'body': json.dumps({
                'message': f'Hello, {name}!',
                'timestamp': context.get_remaining_time_in_millis(),
                'function_name': context.function_name,
                'function_version': context.function_version
            })
        }

        logger.info(f"Response: {json.dumps(response)}")
        return response

    except Exception as e:
        logger.error(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': 'Internal server error',
                'message': str(e)
            })
        }